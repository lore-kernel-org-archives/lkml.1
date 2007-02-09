Return-Path: <linux-kernel-owner+w=401wt.eu-S1946241AbXBIJTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946241AbXBIJTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 04:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946247AbXBIJTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 04:19:37 -0500
Received: from wx-out-0506.google.com ([66.249.82.231]:50152 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946241AbXBIJTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 04:19:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=KDPmxZ5t+i/d+ZtMS7DMy1c4ViXt2NAWhQCMfuSX6FleE9CR2Kk6X3I6aQtKchyW58so/t6e9keEQZi20DHvpU8RpgHXWjafDocztLRioOrNmm3CsSkgdecuwaeKCafHzyTNXfkFMfwE0rf8Xe6oPPEItWzATNpOqHexYD+2WH0=
Message-ID: <45CC3C9C.3050101@gmail.com>
Date: Fri, 09 Feb 2007 04:19:24 -0500
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Emmeran Seehuber <rototor@rototor.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.18.2: sporadic SATA port resets (Broadcom BCM5785 (HT1000))
References: <200702071817.17006.rototor@rototor.de>
In-Reply-To: <200702071817.17006.rototor@rototor.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Emmeran Seehuber wrote:
> we`ve got a database server machine running a 2.6.18.2 vanilla kernel on 
> Debian Etch. The database is MySQL 5. Everything works fine, but sometimes 
> the server "lags", i.e. it doesn`t respond for 30 seconds. We`ve now 
> investigated the problem and found this messages in syslog (and dmesg):
> 
> 15:55:44 omega11 kernel: ata1: port is slow to respond, please be patient
> 15:55:44 omega11 kernel: ata1: soft resetting port
> 15:55:44 omega11 kernel: ata1: port is slow to respond, please be patient
> 15:55:44 omega11 kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 
> 300)
> 15:55:44 omega11 kernel: ATA: abnormal status 0xD0 on port 0xFFFFC2000000401C
> 15:55:44 omega11 last message repeated 5 times
> 15:55:44 omega11 kernel: ata1.00: qc timeout (cmd 0xec)
> 15:55:44 omega11 kernel: ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> 15:55:44 omega11 kernel: ata1: failed to recover some devices, retrying in 5 
> secs
> 15:55:44 omega11 kernel: ata1: hard resetting port
> 15:55:44 omega11 kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 
> 300)
> 15:55:44 omega11 kernel: ata1.00: configured for UDMA/133
> 15:55:44 omega11 kernel: ata1: EH complete
> 15:55:44 omega11 kernel: SCSI device sda: 293046768 512-byte hdwr sectors 
> (150040 MB)
> 15:55:44 omega11 kernel: sda: Write Protect is off
> 15:55:44 omega11 kernel: SCSI device sda: drive cache: write back

This is just the recovery part.  Need more log.  If possible, please 
give a shot at 2.6.20.  It might have fixed your problem or at least 
allow better diagnosis.

> We`ve got this messages up to 5 times a day since as far as our syslogs reach. 
> 
> It seems no kind of queuing is used:
> # cat /sys/block/sda/device/queue_type
> none
> # cat /sys/block/sda/device/queue_depth
> 1
> 
> The server is up for 91 days now and has low to medium load (depending on 
> daytime). Since it`s a production server located in a datacenter, we can`t 
> just test some random kernel on it :(

I see.

> Does somebody have a glue whats going on here? Could it be a hardware failure? 

It might be.  Quite some SATA bug reports turn out to be hardware 
problem, most commonly PSU issues.

> We have an identical machine using the same kernel. It`s used as a webserver. 
> There also this messages shows up, but not that often (10 times in 91 days 
> uptime). If it is a hardware failure, then both machines would been affected 
> by the same hardware problem.

Hmmm...

> What can we do to fix this problem? Is it known? 
> 
> I`ve found many posts related to SATA problems, but none seemed to be about 
> this problem.
> 
> Do you need additional information?

Yeah, please post the content of /var/log/boot.msg if available and the 
result of dmesg and lspci -nn.

-- 
tejun
