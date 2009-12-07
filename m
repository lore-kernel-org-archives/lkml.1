Return-Path: <linux-kernel-owner+w=401wt.eu-S935011AbZLGKK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935011AbZLGKK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 05:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934997AbZLGKK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 05:10:26 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:54804 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934994AbZLGKKY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 05:10:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bSzvxMbZEyNehsc38Dmf3TaYGzAec8xBnX3LbQo9GqseKKqCYcOgfbZjiEXjrcDBni
         EHPafmLJrX9bwzNLx+W5DY0v+grTzm2ZS1dhvsUCco5C8qJT8ll82McJb9ACWcVFGsOH
         2ec2JDk8orgl8jea1r9aM+7em2uqNiZgtOGLI=
MIME-Version: 1.0
In-Reply-To: <4B19A92A.5030804@analog.com>
References: <1244854869-2563-1-git-send-email-vapier@gentoo.org> 
	<14959.1259948697@redhat.com> <4B19A92A.5030804@analog.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 7 Dec 2009 05:10:11 -0500
Message-ID: <8bd0f97a0912070210m4f13e174y154fc82732ef136c@mail.gmail.com>
Subject: Re: [uClinux-dev] [PATCH/RFC] FDPIC: add hook for arches to customize 
	program header parsing
To: Jie Zhang <jie.zhang@analog.com>
Cc: David Howells <dhowells@redhat.com>,
       uClinux development list <uclinux-dev@uclinux.org>,
       linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 4, 2009 at 19:28, Jie Zhang <wrote:
> On 12/05/2009 01:44 AM, David Howells wrote:
>> Mike Frysinger<vapier@gentoo.org>  wrote:
>>> The Blackfin port has custom program header flags/addresses for
>>> automatically loading regions into the dedicated on-chip SRAM.  So add a
>>> hook for ports to leverage.
>>
>> Now that I've ACK'd this, I feel I'm going to have to NAK it.  I'm not
>> against
>> the general concept, but:
>>
>>> +               do_munmap(mm, *maddr, phdr->p_memsz + *disp);
>>
>> There needs to be a mapping covering the SRAM region for the purposes of
>> the
>
> Our GDB is still lack of the feature to debug applications using SRAM.

semi true.  L1 text appears to work fine:
(gdb) stepi
0xffa02aac in moo ()
(gdb) dis
Dump of assembler code from 0xffa02aac to 0xffa02aec:
0xffa02aac <moo+0>:     LINK 0xc;               /* (12) */
0xffa02ab0 <moo+4>:     [FP + 0x8] = R0;
....

but L1 data doesnt seem to work (probably something simple to fix in
our kernel ptrace?):
(gdb) print i
Cannot access memory at address 0xff803e58

the simple code:
int i __attribute__((l1_data));

> So this part of code was not got exercised. So if we remove this line, can
> this patch got merged?

this code does get exercised -- it's run every time code is loaded
from initramfs for example.  the
-mike
