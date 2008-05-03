Return-Path: <linux-kernel-owner+w=401wt.eu-S965433AbYECAPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965433AbYECAPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 20:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762179AbYECAPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 20:15:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:33379 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759164AbYECAPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 20:15:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XAHCOzQTzKw1BclDurpIasKvcL4aI7ZokwIRT0D2EPPZU+czBRhrB3Qz0OTyrin8hRgWitgi7Li5WskO5oT/6zBEdAOpg/4eUW3xRG04xhhnzbjf3zc3N267SI8FMn6EL9Wd7kaamGQzvlmHXReURTgbDWvbsbbL1Luyax9fPf0=
Subject: Re: [PATCH 12/12] net: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
In-Reply-To: <20080502170802.456493a5.akpm@linux-foundation.org>
References: <1209754916.26173.39.camel@brick>
	 <20080502.162515.14823435.davem@davemloft.net>
	 <20080502163131.a13c0774.akpm@linux-foundation.org>
	 <1209772363.26173.101.camel@brick>
	 <20080502170802.456493a5.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 17:15:55 -0700
Message-Id: <1209773755.26173.114.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-02 at 17:08 -0700, Andrew Morton wrote:
> > > Yup.  After a bit of testing and tyre-kicking I'll probably slip
> > > lib-add-ascii-hex-helper-functions.patch into mainline so that we can
> > > trickle all the *-use-the-common-ascii-hex-helpers.patch patches out to the
> > > various maintainers.
> > > 
> > 
> > I suppose the hex_asc array and hex_to_int could also use
> > EXPORT_SYMBOL().
> 
> gack.  How could you do all those patches without discovering this?  Please
> go give your QA staff a wedgie.

Sorry about the fat-fingered send, as before:

allyesconfig :(

> yes, hex_to_u8() is more specific and better defined than hex_to_int().
> 
> Although anally it should perhaps be two_digit_hex_to_ulong,
> four_digit_hex_to_ulong, etc.
> 
> ho hum, I'll drop them all.

int hex_char_to_int(char ch)
{
	return -1 if not [a-fA-F0-9]
}

int hex_to_u8(const char *buf, u8 *val)
int hex_to_u16(const char *buf, u16 *val)
int hex_to_u32(const char *buf, u32 *val)
int hex_to_u64(const char *buf, u64 *val)

Which return the number of chars read and reads up to a maximum of
2,4,8,16 chars respectively and returns early if a non-hex char
is encountered.

Thoughts?

Harvey

