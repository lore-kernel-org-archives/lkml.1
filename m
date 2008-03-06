Return-Path: <linux-kernel-owner+w=401wt.eu-S1761898AbYCFIk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761898AbYCFIk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 03:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbYCFIkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 03:40:12 -0500
Received: from gv-out-0910.google.com ([216.239.58.188]:8968 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbYCFIkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 03:40:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=KEIuk6LCRxV12RFyQiRWUTe7GdIlgQRyl+5W+cM5wKmRBoVSKnej1WSMAjKUKPR4yrwW6VZyqEUFbLqLxVGAU8DjGSEiX/N1yNnB/KeWpOVJV/6MYnPVY0VTnRJNzSSr1V3DOXIF9xTDOw+sZuDyltywMDg3h02zZ0SFl4IKWw0=
Message-ID: <47CFADDF.20200@gmail.com>
Date: Thu, 06 Mar 2008 17:39:59 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Re: Unknown SATA PIIX PCI device ID 0x29b6
References: <Pine.LNX.4.64.0802282306190.10087@axis700.grange> <20080228225603.2764bfd1@core> <Pine.LNX.4.64.0802290010320.10498@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0802290010320.10498@axis700.grange>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> Indeed! It was in "IDE" mode, and 2 out of the 3 chips were handled by the 
> piix driver (btw, why did Intel put 3 different SATA controllers on one 
> board?). I switched it to AHCI mode (the third possibility is RAID) and 
> indeed a kernel with (only) ahci driver managed to bring them up! 
> Although, the eSATA link was "slow to respond":
> 
> ata4: port is slow to respond, please be patient (Status 0x80)
> ata4: softreset failed (device not ready)
> ata4: port is slow to respond, please be patient (Status 0x80)
> ata4: softreset failed (device not ready)
> ata4: port is slow to respond, please be patient (Status 0x80)
> ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata4.00: ATA-7: WDC WD1600BB-00RDA0, 20.00K20, max UDMA/100
> ata4.00: 312581808 sectors, multi 16: LBA48
> ata4.00: applying bridge limits
> ata4.00: configured for UDMA/100
> 
> but then it did manage it. Is such a delay normal?

If you hotplugged it, sometimes drives don't respond too well and takes
a few retries to talk to it.  How long did the whole thing take?  And is
it always like that?

> One more question, what do UDMA numbers mean in SATA context? The internal 
> SATA disk is "ata1.00: configured for UDMA/133", but should be SATA-2.

1.00 is port 1 device 00 and UDMA numbers don't mean much to SATA devices.

Thanks.

-- 
tejun
