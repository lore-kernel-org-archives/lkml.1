Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbXGECVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbXGECVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 22:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbXGECVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 22:21:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:33648 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbXGECVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 22:21:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tY0k2nQMk7Y/aSvZigC0Ip3isqVty97HuDvSy/iDZQIK/i0qwoulPUicAfAp5DuaMbCnUxrIsDzHHAYwns6zLPrBt8UxGqu5/CLjd2OTcWeLWEA2fj3kzLLVvu233/KB1lIZBsz00grDUbaUR39mFlMki2wrdjYwPjTJYgku3VI=
Message-ID: <468C5591.1040202@gmail.com>
Date: Thu, 05 Jul 2007 11:21:05 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux-ide <linux-ide@vger.kernel.org>
Subject: Re: ata1: soft resetting port
References: <1182260902.14805.60.camel@localhost>	 <4689EF48.8090506@gmail.com> <1183545657.22999.15.camel@localhost>	 <468BE06D.4010507@gmail.com> <1183576924.4697.36.camel@localhost>
In-Reply-To: <1183576924.4697.36.camel@localhost>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren Sonnenburg wrote:
>>> pci_express 0000:00:1c.2:pcie03: resuming
>>> sr 0:0:0:0: resuming
>>> sd 2:0:1:0: resuming
>>> sd 2:0:1:0: [sda] Starting disk
>>> ata1.00: configured for UDMA/33
>>> ata3.01: revalidation failed (errno=-2)
>>> ata3: failed to recover some devices, retrying in 5 secs
>>> ata3.01: configured for UDMA/133
>> Hmmm... That's NODEV_HINT being triggered after resume.  Probably the
>> device isn't ready to respond yet at that point.  How reproducible is
>> the problem?
> 
> quite reproducible:
> 
> $ dmesg | grep 'revalidation failed' | wc -l
> 4

Hmmm... Thanks.  I think the best we can do is 1. don't wait for disk
revalidation during resume 2. retry faster.  Just in case, please post
the result of "hdparm -I /dev/sdX" where sdX is the device at ata3.01.

-- 
tejun
