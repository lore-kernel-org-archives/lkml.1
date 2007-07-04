Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbXGDSBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbXGDSBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 14:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbXGDSBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 14:01:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:39310 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbXGDSBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 14:01:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ozds8CNIe1FYSPK1ZwvOLsaD0JmgvTNaSNUmoFBSHMl5biid1Djm2hwfUs3cMPH8be/KH2seVet0DAcslTa0pe+HdPhXgP7M87klSC9qW4DVK+0d+PHnHltyZJZNx6abeqNae6AZc0dGlNkyRY21hG1a1tXSEFAnYPuvGX0hfqI=
Message-ID: <468BE06D.4010507@gmail.com>
Date: Thu, 05 Jul 2007 03:01:17 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux-ide <linux-ide@vger.kernel.org>
Subject: Re: ata1: soft resetting port
References: <1182260902.14805.60.camel@localhost>	 <4689EF48.8090506@gmail.com> <1183545657.22999.15.camel@localhost>
In-Reply-To: <1183545657.22999.15.camel@localhost>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren Sonnenburg wrote:
> On Tue, 2007-07-03 at 15:40 +0900, Tejun Heo wrote:
>> Soeren Sonnenburg wrote:
>>> Dear List,
>>>
>>> since the switch to 
>>>
>>> CONFIG_ATA=y
>>> CONFIG_ATA_ACPI=y
>>> CONFIG_ATA_PIIX=y,
>>>
>>> the ATA_PIIX driver manages both, internal sata disk aswell as cd/dvd
>>> rom. However I am being flooded with the error messages below (well they
>>> appear from time to time, dominating dmesg). 
>>>
>>> This happens on kernel 2.6.22-rc5, I am copying relevant parts from dmesg:
>> Does 2.6.22-rc7 fare better?
> 
> Yes indeed. The only thing I've seen in the last two days was the
> following on resume:
> 
> pci_express 0000:00:1c.2:pcie03: resuming
> sr 0:0:0:0: resuming
> sd 2:0:1:0: resuming
> sd 2:0:1:0: [sda] Starting disk
> ata1.00: configured for UDMA/33
> ata3.01: revalidation failed (errno=-2)
> ata3: failed to recover some devices, retrying in 5 secs
> ata3.01: configured for UDMA/133

Hmmm... That's NODEV_HINT being triggered after resume.  Probably the
device isn't ready to respond yet at that point.  How reproducible is
the problem?

-- 
tejun
