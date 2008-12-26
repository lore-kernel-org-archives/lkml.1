Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbYLZHpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbYLZHpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 02:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbYLZHpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 02:45:33 -0500
Received: from main.gmane.org ([80.91.229.2]:38663 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbYLZHpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 02:45:33 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Kernel panic with upgrade to 2.6.28
Date: Fri, 26 Dec 2008 01:45:20 -0600
Message-ID: <49548B90.7070303@shaw.ca>
References: <1230230537.3368.13.camel@montroll.chem.mcgill.ca>	 <ce0170d90812251053w46601ce4yb62765270abf0632@mail.gmail.com> <1230232263.3368.17.camel@montroll.chem.mcgill.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Sergio Luis <eeeesti@gmail.com>
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <1230232263.3368.17.camel@montroll.chem.mcgill.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ronis wrote:
> Thanks for the reply.  Here are the files you wanted to see:
> 
> dmsg from working kernel:
> 

(snip)

> Uniform Multi-Platform E-IDE driver
> ide_generic: please use "probe_mask=0x3f" module parameter for probing
> all legacy ISA IDE ports
> Probing IDE interface ide0...
> hda: ST340014A, ATA DISK drive
> Switched to high resolution mode on CPU 1
> Switched to high resolution mode on CPU 0
> hdb: ST340014A, ATA DISK drive
> Probing IDE interface ide1...
> hdc: SONY CD-RW/DVD-ROM CRX330E, ATAPI CD/DVD-ROM drive
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> ide1 at 0x170-0x177,0x376 on irq 15
> hda: max request size: 512KiB
> hda: 78165360 sectors (40020 MB) w/2048KiB Cache, CHS=16383/255/63
> hda: cache flushes supported
>  hda: hda1 hda2
> hdb: max request size: 512KiB
> hdb: 78125000 sectors (40000 MB) w/2048KiB Cache, CHS=16383/255/63
> hdb: cache flushes supported
>  hdb: hdb1 hdb2 hdb3
> hdc: ATAPI 48X DVD-ROM CD-R/RW drive, 2048kB Cache

Your kernel configuration for IDE seems to be wrong. You're using 
ide_generic which no remotely modern system should be using. You should 
enable one of the chipset-specific drivers under "PCI IDE chipsets 
support". I suspect there was a change so that ide_generic no longer 
attaches to your IDE controller whereas it did before.

(Really if you're up for making changes one should just disable the old 
IDE stuff and switch to libata but that's another matter.)

