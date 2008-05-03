Return-Path: <linux-kernel-owner+w=401wt.eu-S965335AbYECAIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965335AbYECAIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 20:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932631AbYECAIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 20:08:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932592AbYECAIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 20:08:34 -0400
Date: Fri, 2 May 2008 17:08:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] net: use the common ascii hex helpers
Message-Id: <20080502170802.456493a5.akpm@linux-foundation.org>
In-Reply-To: <1209772363.26173.101.camel@brick>
References: <1209754916.26173.39.camel@brick>
	<20080502.162515.14823435.davem@davemloft.net>
	<20080502163131.a13c0774.akpm@linux-foundation.org>
	<1209772363.26173.101.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 May 2008 16:52:43 -0700
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> On Fri, 2008-05-02 at 16:31 -0700, Andrew Morton wrote:
> > On Fri, 02 May 2008 16:25:15 -0700 (PDT)
> > David Miller <davem@davemloft.net> wrote:
> > 
> > > From: Harvey Harrison <harvey.harrison@gmail.com>
> > > Date: Fri, 02 May 2008 12:01:56 -0700
> > > 
> > > > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > > 
> > > Acked-by: David S. Miller <davem@davemloft.net>
> > > 
> > > This has to go in via who ever adds the first patch
> > > with the actual helpers, so I won't apply this one.
> > 
> > Yup.  After a bit of testing and tyre-kicking I'll probably slip
> > lib-add-ascii-hex-helper-functions.patch into mainline so that we can
> > trickle all the *-use-the-common-ascii-hex-helpers.patch patches out to the
> > various maintainers.
> > 
> 
> I suppose the hex_asc array and hex_to_int could also use
> EXPORT_SYMBOL().

gack.  How could you do all those patches without discovering this?  Please
go give your QA staff a wedgie.

--- a/lib/hexdump.c~lib-add-ascii-hex-helper-functions-fix
+++ a/lib/hexdump.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 
 const char hex_asc[] = "0123456789abcdef";
+EXPORT_SYMBOL(hex_asc);
 
 /**
  * hex_to_int - convert a single hex ASCII char to an integer value
@@ -32,6 +33,7 @@ int hex_to_int(char ch)
 		return ch - '0';
 	return -1;
 }
+EXPORT_SYMBOL(hex_to_int);
 
 /**
  * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
_


> Also, As I've looked further around the tree, there seem to be a lot
> of hex_to_int/long variants around the tree, so what I'm thinking is
> the current hex_to_int becomes hex_to_u8 and I'll add a:
> 
> /**
>  * hex_to_u32 - read a u32 from a char buffer
>  * @buf: buffer to read ascii chars from
>  * @val: where to put the u32
>  *
>  * Read hex-ascii chars into a u32.  Return the number of chars read.
>  * A maximum of 8 chars will be read, if a char not in [a-f][A-F][0-9]
>  * is encountered, the function returns.
>  */
> int hex_to_u32(const char *buf, u32 *val)
> 
> Similar to the above, but a max of 16 chars will be read.
> int hex_to_u64(const char *buf, u64 *val)
> 
> If this api is better, I suppose:
> 
> int hex_to_u8 - max of two chars
> int hex_to_u16 - max of 4
> int hex_to_u32 - max of 8
> int hex_to_u64 - max of 16
> 
> Could be added around a common function that takes the max length as
> an additional arg.
> 

yes, hex_to_u8() is more specific and better defined than hex_to_int().

Although anally it should perhaps be two_digit_hex_to_ulong,
four_digit_hex_to_ulong, etc.

ho hum, I'll drop them all.


