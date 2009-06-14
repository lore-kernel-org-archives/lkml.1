Return-Path: <linux-kernel-owner+w=401wt.eu-S1763390AbZFNAdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763390AbZFNAdb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 20:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761817AbZFNAdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 20:33:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:26038 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759072AbZFNAdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 20:33:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=RedNyINC7S6Zg+KW75CzvWzlRX0Y4bU6qPxKVfSnVCEtlxMTJe20CBkYYKwf2kgrLF
         //8PLnFaVTaOEyYWu9vcVc74ug2V0mwCrp+/4o8zr43eT9tBfA9T9HlzeP4qUbvDzqAb
         kl1L2icnFNJxLPrRDm7ML+CJo2dJMXlRYE5KI=
MIME-Version: 1.0
In-Reply-To: <20090613182540.GJ16220@shareable.org>
References: <1244854869-2563-1-git-send-email-vapier@gentoo.org> 
	<20090613161323.GC16220@shareable.org> <8bd0f97a0906130940j6b5e578bha8193f59d03c2f05@mail.gmail.com> 
	<20090613182540.GJ16220@shareable.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 13 Jun 2009 20:32:51 -0400
Message-ID: <8bd0f97a0906131732v5394eaf5gb0f7862dfe7f58f3@mail.gmail.com>
Subject: Re: [uClinux-dev] [PATCH/RFC] FDPIC: add hook for arches to customize 
	program header parsing
To: Jamie Lokier <jamie@shareable.org>
Cc: uClinux development list <uclinux-dev@uclinux.org>,
       linux-kernel@vger.kernel.org, Jie Zhang <jie.zhang@analog.com>,
       Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 14:25, Jamie Lokier wrote:
> Mike Frysinger wrote:
>> On Sat, Jun 13, 2009 at 12:13, Jamie Lokier wrote:
>> > Mike Frysinger wrote:
>> >> From: Jie Zhang <jie.zhang@analog.com>
>> >>
>> >> The Blackfin port has custom program header flags/addresses for
>> >> automatically loading regions into the dedicated on-chip SRAM.  So add a
>> >> hook for ports to leverage.
>> >
>> > It looks like a way for certain special executables to load themselves
>> > into fixed regions of the on-chip SRAM - and promptly crash if another
>> > executable does the same.  Not so much a general executable format, as
>> > a hack to load something specific which should only be done once at a
>> > time.  What am I missing here?
>>
>> the addresses are keys, not fixed and/or "real" addresses
>
> Oh, I see that is indeed quite nice :-)
>
> I see it checks for both flags and special address values.  Are the
> special address checks mainly historical, as usually flags/types are
> used to designate special memory types in ELF.

the EF bits are more for smaller/statically linked applications where
you want to place the entire ELF into SRAM.  the special PHDRs are for
selectively compiled code -- i.e. you've done a little bit of
profiling and testing and know which ones are the hot spots.
-mike
