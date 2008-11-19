Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbYKSRQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbYKSRQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 12:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbYKSRQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 12:16:35 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:38535 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbYKSRQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 12:16:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=csDBiEaE4b3ADWUfxbuPTb7GbN8mSY+rxwKex9AarrdaVgGPypKPaXBdl/scHKFs4V
         dsyQwsvt81Gw0XBjlpL112B0+KgEYOxL1Gyhb01eI/6kLLxEC60624q1knGq5CZvqW+l
         u+SZb1NZL/RuZiQbwzRP9ezS4dy9D8tgDknIU=
Subject: Re: + unaligned-introduce-common-header.patch added to -mm tree
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, bryan.wu@analog.com,
       "David S. Miller" <davem@davemloft.net>, dhowells@redhat.com,
       Greg Ungerer <gerg@uclinux.org>, grundler@parisc-linux.org,
       heiko.carstens@de.ibm.com, hskinnemoen@atmel.com,
       ink@jurassic.park.msu.ru, kyle@mcmartin.ca, lethal@linux-sh.org,
       linux-arch@vger.kernel.org, mingo@elte.hu,
       Paul Mackerras <paulus@samba.org>, Ralf Baechle <ralf@linux-mips.org>,
       Russell King <rmk@arm.linux.org.uk>, rth@twiddle.net,
       schwidefsky@de.ibm.com, takata@linux-m32r.org, tglx@linutronix.de,
       tony.luck@intel.com, ysato@users.sourceforge.jp, zankel@tensilica.com,
       Roman Zippel <zippel@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0811190919280.27671@anakin>
References: <200811190614.mAJ6EsXA007330@imap1.linux-foundation.org>
	 <Pine.LNX.4.64.0811190919280.27671@anakin>
Content-Type: text/plain
Date: Wed, 19 Nov 2008 09:16:26 -0800
Message-Id: <1227114986.13182.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-19 at 09:21 +0100, Geert Uytterhoeven wrote:
> On Tue, 18 Nov 2008, akpm@linux-foundation.org wrote:
> > Subject: unaligned: introduce common header
> > From: Harvey Harrison <harvey.harrison@gmail.com>
> > 
> > There are two common cases in the kernel, one where unaligned access is OK
> > for an arch and one where the arch uses a packed-struct for the native
> > endianness and opencoded C byteshifting for the other endianness. 
> > Consolidate these two implementations in asm-generic/unaligned.h
> > 
> > Arches that require no special handling of unaligned access can define
> > _UNALIGNED_ACCESS_OK in their asm/unaligned.h before including the generic
> > version.
> > 
> > +static inline void __put_le32_noalign(u8 *p, u32 val)
> > +{
> > +	__put_le16_noalign(p + 2, val >> 16);
> > +	__put_le16_noalign(p, val);
> 
> Isn't it more logical to reverse the order, to store in increasing memory
> locations:
> 
> 	__put_le16_noalign(p, val);
> 	__put_le16_noalign(p + 2, val >> 16);
> 

All of the byteshifting versions were cribbed from the ARM implementation.

I'm not sure if there was a particular reason for doing it in this order, but
a lot of work seems to have gone in to minimize register usage.

See include/asm-arm/unaligned.h circa 2.6.25.

Harvey

