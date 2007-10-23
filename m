Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbXJWII1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbXJWII1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 04:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbXJWIIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 04:08:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:32443 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbXJWIIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 04:08:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Z1ZAfaBLT5snfbbX9BY4Z2Zo7TBtebtpQinIQ1Ljr/DoIgbQEwUSC44S5jVn2b6B5OTq2hUNKeXCGwlTkxBvUEbRKOTA8SVYigX1ZFLGDMn2rnmj7sXLFMhwD68vMJE/gV8M43YUsqfToMn2+yLH5aLx/8+6uxzcaG5wdldd1nE=
Message-ID: <471DABE1.40301@gmail.com>
Date: Tue, 23 Oct 2007 17:08:01 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Bernd Schubert <bs@q-leap.de>,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] faster workaround
References: <200710081709.18253.bs@q-leap.de>	<200710101112.20448.bs@q-leap.de>	<200710111409.56210.bs@q-leap.de>	<200710111433.23833.bs@q-leap.de>	<20071011142628.48272a4a@the-village.bc.nu>	<470E30F9.5060705@garzik.org> <20071011155024.46007973@the-village.bc.nu> <470E3A35.4000104@garzik.org>
In-Reply-To: <470E3A35.4000104@garzik.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Alan Cox wrote:
>>> 2) Once we identified, over time, the set of drives affected by this
>>> 3112 quirk (aka drives that didn't fully comply to SATA spec), the
>>> debugging of corruption cases largely shifted to the standard
>>> routine: update the BIOS, replace the
>>> cables/RAM/power/mainboard/slot/etc. to be certain of problem location.
>>
>> Except for the continued series of later SI + Nvidia chipset (mostly)
>> pattern which seems unanswered but also being later chips I assume
>> unrelated to this problem.
> 
> The SIL_FLAG_MOD15WRITE flag is set in sil_port_info[] is set according
> to the best info we have from SiI, which indicates that 3114 and 3512 do
> not have the same problem as the 3112.

I don't think this data corruption problem w/ sil3114 is related to
m15w.  m15w workaround slows down things quite a bit and is likely to
hide problems on PCI bus side.  There are reports of data corruption
with 3114 on nvidia (most common), via and now amd chipsets.  There's
one on intel too but IIRC wasn't too definite.

According to a user, freebsd didn't have data corruption problem on the
same hardware.  I copied PCI FIFO setup code (ours is broken BTW) but it
didn't fix the problem.

I'll try to reproduce the problem locally and hunt it down.

Thanks.

-- 
tejun
