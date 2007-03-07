Return-Path: <linux-kernel-owner+w=401wt.eu-S1751294AbXCGM1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbXCGM1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 07:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbXCGM1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 07:27:34 -0500
Received: from wx-out-0506.google.com ([66.249.82.238]:10417 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbXCGM1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 07:27:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=dZnCm+bkdHvff7PWy4rYyf7WVHeAs4s8BgcZzRVHFrn5yU+KaEzug/X+f2qcEPt+7gV884P+xmG/8wdGI2Sh3/9eNqmvsYZypc5LrGxm0iWwC10RMNRh7fNOdC3LMjcrP61FKiUxX3tfAr9aRcbc14jtMGpEsLfcEsBVLSryERs=
Message-ID: <45EEAFB4.3060306@gmail.com>
Date: Wed, 07 Mar 2007 21:27:32 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Conke Hu <conke.hu@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] ATAPI command TEST_UNIT_READY never succeeds!
References: <5767b9100703070409o3e094420rf7ccffc436332184@mail.gmail.com> <5767b9100703070423y194bf492wad28ddc66ab98775@mail.gmail.com>
In-Reply-To: <5767b9100703070423y194bf492wad28ddc66ab98775@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Conke Hu wrote:
> On 3/7/07, Conke Hu <conke.hu@gmail.com> wrote:
>> Hi,
>>     Do you ever noticed that the ATAPI command TEST_UNIT_READY always
>> fails to execute !?
>>     I debugged in the following environments:
>>         piix + Intel ICH6/ICH7 PATA
>>         atiixp + ATI SB600 PATA
>>         libata + ata_piix + Intel ICH6/ICH7 PATA
>>         libata + sata_sil24 + Silicon Image 3132
>>         libata + ahci + ATI SB600 SATA
>>         libata + ahci + Intel AHCI
>>     but none of them can execute TEST_UNIT_READY command successfully.
>>     For example, in ahci driver, ahci_interrupt() reads port status as
>> 0x4000_0000, which indicates an taskfile error.
> ~~~~~~~~~~~~~~~~~~
> 
> 0x4000_0001, not 0x4000_0000, sorry.
> 
> more precisely speaking, ahci_host_intr() reads PORT_IRQ_STAT as
> 0x4000_0001, not the  expected 0x0000_0001.

I've read your last posting about this, but forgot to follow up.  TUR is
supposed to fail if ATAPI device doesn't have media loaded.  TUR fails
and sense data returns device not ready - media not present.  That's the
normal operation.  Does TUR fail even with media loaded or is sense data
not properly fetched?

-- 
tejun
