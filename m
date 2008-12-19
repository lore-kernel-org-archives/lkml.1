Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbYLSLbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbYLSLbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 06:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYLSLbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 06:31:42 -0500
Received: from h155.mvista.com ([63.81.120.155]:51221 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751355AbYLSLbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 06:31:41 -0500
Message-ID: <494B8617.3020808@ru.mvista.com>
Date: Fri, 19 Dec 2008 14:31:35 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>,
       Mario Schwalbe <schwalbe@inf.tu-dresden.de>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] ide: Fix ata_id_has_dword_io to return DWORD I/O support
 properly
References: <494A5BBF.8000807@inf.tu-dresden.de>	<494A837A.50801@garzik.org>	<494A8768.4080100@ru.mvista.com>	<200812182142.16533.bzolnier@gmail.com> <20081218224010.45e3ce55@lxorguk.ukuu.org.uk>
In-Reply-To: <20081218224010.45e3ce55@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Cox wrote:

>> OTOH the current patch is safe even for 2.6.28 (based on years of experience
>> with the check that we had in IDE subsystem) and will fix some libata drivers
>> (pata_legacy, pata_qdi and pata_winbond) to use dword IO on >= ATA-2 devices.
>>
>> [ In reality this a regression fix for IDE -> libata conversion as it is a
>>   huge performance improvement for the above mentioned DMA-less drivers. ]
>>     
>
> The 32bit PIO support is already queued up and went to Jeff a while ago
> so thats all in hand - its btw a big win on some suprising chipset cases
> including Intel ICH chipsets.
>   

   This is indeed strange...

>> Jeff, I would like to merge it through IDE tree since the other patch depends
>> on it but if you want to go ahead and push it to Linus earlier feel free to
>> do it (or I can include it into the next IDE fixes pull request if you like).
>>     
>
> Its still broken. You cannot use the version check for versions below 3.
>   

   The word is reserved since ATA-2, and ata_id_major_version() should 
be returning 0 for pre-ATA-3 drives, so I don't know what else can be 
done here...

> I remain unconvinced we should be looking at it anywhere except specific
> pure ISA cycle pass through hardware and thus it belongs as a helper for
>   

   I'm still not getting how drive can support or not support "DWORD 
I/O" -- you certainly can't have 32-bit I/O cycle on ISA (only on EISA) 
and you certainly cannot translate 32-bit cycle to the ATA bus. I 
remember I had some hypotheses before but they turned out to be 
inconsistent.

> those drivers not as ata_has_mumble stuff as its not ATA - eide_* maybe.
>   

   Indeed, already ATA-1 says that the word 48 is "includedfor backwards 
compatible VU use".

> Alan
>   

MBR, Sergei


