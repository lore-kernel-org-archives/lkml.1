Return-Path: <linux-kernel-owner+w=401wt.eu-S1751967Ab0AJEeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab0AJEeB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 23:34:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040Ab0AJEeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 23:34:01 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:61469 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab0AJEeA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 23:34:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fI5YSYpeHxooTnz+qjx2OvCXSdTwjvVSCAGPIpYm2LHPwUcHUO6hMgvbCwam9iotuF
         Fnfv/JghRWqLQjdP+jFBa6Uovte5VYwVsrxgbJF5pXikIAwkiRuIhurn9rkYAH3BaOns
         iYdJmQDTaTacOdL4ld0BDoa47QHf2egzji5Qw=
MIME-Version: 1.0
In-Reply-To: <4B484829.6060405@kernel.org>
References: <64bb37e0912250122n4e0e1842q88c0dad7e99ec6a7@mail.gmail.com>
	 <4B484829.6060405@kernel.org>
Date: Sun, 10 Jan 2010 05:33:58 +0100
Message-ID: <64bb37e1001092033r1f0b4defw46c1a07101bb2d1b@mail.gmail.com>
Subject: Re: MSI broken in libata?
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 9, 2010 at 10:11 AM, Tejun Heo <tj@kernel.org> wrote:
> On 12/25/2009 06:22 PM, Torsten Kaiser wrote:
>> As reported in http://lkml.org/lkml/2009/12/19/82 the new MSI support
>> for sata_sil24 does not work for me.
>> This is still the same with 2.6.33-rc2.
>>
>> Why I think, this might be a problem within libata:
>>  * other drivers can use MSI successful on my system (tg3, radeon, hda-intel)
>>  * happens both in sata_sil24 and sata_nv
>>  * the count in /proc/interrupts increases for the MSIs assigned to
>> sata_sil24/sata_nv, so interrupt delivery seems to work
>>  * only writing seems to fail
>
> How does it fail?  Timeouts?

Yes, timeouts.
I posted the error messages in http://lkml.org/lkml/2009/12/19/82 and
http://lkml.org/lkml/2010/1/6/60

> Also, ahci enables MSI by default if
> available and works fine on many configurations so I don't think
> anything in libata core layer is broken regarding MSI (there just
> isn't anything which can break).

The system I'm using does not have a ahci compatible controller, so I
could not compare this.
(And my other system that is using ahci, does not use MSI for that)

I just found it suspicious that 3 other drivers (tg3, hda-intel and
radeon) can use MSI, but both of the libata drivers (sata_sil24 and
sata_nv) fail in a similar way.

I did try the patch from Robert Hancock in
http://lkml.org/lkml/2010/1/6/417 ,but without success.

if you need any more information, or have something for me to try,
please just ask. I did look at the code and the documentation about
enabling MSI, but did not see anything (obvious) wrong, so I don't
know what to try next.

Torsten
