Return-Path: <linux-kernel-owner+w=401wt.eu-S937357AbYEBXw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937357AbYEBXw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764497AbYEBXwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:52:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:44915 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762179AbYEBXwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:52:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ur5aajA4cP87+0oC0EIqZeui0GMDdGwYmNDqh1yGnzbNGS9L7Md7lfzkAhYW08ikIoVcSSp4/EdGopc9j1umwJu2PC1ok7UxuwGaJjm1i3ksiZPsPVv2RJ1loVoOERm+VyFURFz78aPxLJYbTic8q1z9DkgezFVD64yJo8hvclw=
Subject: Re: [PATCH 12/12] net: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20080502163131.a13c0774.akpm@linux-foundation.org>
References: <1209754916.26173.39.camel@brick>
	 <20080502.162515.14823435.davem@davemloft.net>
	 <20080502163131.a13c0774.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 16:52:43 -0700
Message-Id: <1209772363.26173.101.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-02 at 16:31 -0700, Andrew Morton wrote:
> On Fri, 02 May 2008 16:25:15 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> > From: Harvey Harrison <harvey.harrison@gmail.com>
> > Date: Fri, 02 May 2008 12:01:56 -0700
> > 
> > > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > 
> > Acked-by: David S. Miller <davem@davemloft.net>
> > 
> > This has to go in via who ever adds the first patch
> > with the actual helpers, so I won't apply this one.
> 
> Yup.  After a bit of testing and tyre-kicking I'll probably slip
> lib-add-ascii-hex-helper-functions.patch into mainline so that we can
> trickle all the *-use-the-common-ascii-hex-helpers.patch patches out to the
> various maintainers.
> 

I suppose the hex_asc array and hex_to_int could also use
EXPORT_SYMBOL().

Also, As I've looked further around the tree, there seem to be a lot
of hex_to_int/long variants around the tree, so what I'm thinking is
the current hex_to_int becomes hex_to_u8 and I'll add a:

/**
 * hex_to_u32 - read a u32 from a char buffer
 * @buf: buffer to read ascii chars from
 * @val: where to put the u32
 *
 * Read hex-ascii chars into a u32.  Return the number of chars read.
 * A maximum of 8 chars will be read, if a char not in [a-f][A-F][0-9]
 * is encountered, the function returns.
 */
int hex_to_u32(const char *buf, u32 *val)

Similar to the above, but a max of 16 chars will be read.
int hex_to_u64(const char *buf, u64 *val)

If this api is better, I suppose:

int hex_to_u8 - max of two chars
int hex_to_u16 - max of 4
int hex_to_u32 - max of 8
int hex_to_u64 - max of 16

Could be added around a common function that takes the max length as
an additional arg.

Thoughts?

Harvey


