Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbZB1Uk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbZB1Uk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 15:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbZB1UkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 15:40:11 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:12297 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbZB1UkK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 15:40:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jKPkw+DIm/DLPCg6brBAOkQ5+uDvJGkPBYcdcsnBpTU1FeP0Nmnrvog8LimGbiy3gQ
         DQRjDnjhlnCGy0cgADoHhMHdE827Xkp2JSUv5MyoeeqCw9/4tUlazHXomcp616Sc/qw8
         yzBDOpZym6pVVI+2AVkOmB7GSFRYwO9Rn9l5E=
MIME-Version: 1.0
In-Reply-To: <49A8F319.3030802@goop.org>
References: <1235785882-17580-1-git-send-email-jeremy@goop.org>
	 <1235785882-17580-4-git-send-email-jeremy@goop.org>
	 <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com>
	 <49A8E235.6010900@goop.org> <20090228071534.GB9351@elte.hu>
	 <49A8EA1A.50802@kernel.org> <49A8ED3D.1060704@kernel.org>
	 <49A8F319.3030802@goop.org>
Date: Sat, 28 Feb 2009 12:40:08 -0800
X-Google-Sender-Auth: 9db1285b52119012
Message-ID: <86802c440902281240i11423a95l98e330768ac6ca18@mail.gmail.com>
Subject: Re: brk patches..
From: Yinghai Lu <yinghai@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 12:17 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Yinghai Lu wrote:
>>
>> Yinghai Lu wrote:
>>
>>>
>>> wonder if boot loader check uncompress size aka vmlinux size in bzImage
>>> before it find one good position for bzImage...?
>>>
>>>
>>
>> Jeremy's brk patches may break:
>> 1. kexec load 64bit vmlinux on some ram that near the memory hole etc.
>> blindly to use ram after _end may have some problem
>> 2. coreboot aka linux is using elf (by mkelfImage : vmlinux + initrd),
>> initrd became one section after _end...
>> could cause initrd get overwrite... by extend _brk
>>
>
> But its no different from what i386 does now to allocate its initial
> pagetables.  How does this not break now?
>

it will try to use initial page table af first, and it is not big
enough, it will according to e820 and other reserved_early areas to
find good positions.

YH
