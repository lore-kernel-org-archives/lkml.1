Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbYGNMCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbYGNMCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 08:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbYGNMCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 08:02:40 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:13479 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbYGNMCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 08:02:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=XjTeBdpbp8SEHZhF5aQXShzY8QWM/5fJVAoW7jMintQK5l66PBoR2X6YxUS6j5stgZ
         ADigvKXTAir9ksVVIsCE4JCgRl5yjCpVlNP+32290kHGMCpTmGaag/pjjMgD6YRCXBuC
         cFZKEQtDcTZsLcfhBDy3NTMay1+Muk/Zz1bn4=
Message-ID: <487B403F.5040704@gmail.com>
Date: Mon, 14 Jul 2008 21:02:07 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Piter PUNK <piterpunk@slackware.com>
CC: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Regression: kernel 2.6.24{,.1} ahci problem, does not boot
References: <Pine.LNX.4.63.0806141945270.2761@bob.slackware.com>
In-Reply-To: <Pine.LNX.4.63.0806141945270.2761@bob.slackware.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Piter PUNK wrote:
> I have a notebook with SiS968. It works with 2.6.23.x
> kernels but not with 2.6.24+ kernels. Probably my
> problem is the same of this old thread:
> 
> http://lkml.org/lkml/2008/2/14/263
> 
> The error is exactly the same.
> 
> Looking the changes from 2.6.23 to 2.6.24 in
> 
> http://kernelnewbies.org/Linux_2_6_24#head-f29764e7ef293be84e2f8aa1b08b8816b15ebfca
> 
> I try to revert two commits to see which one brokes
> my SATA device support. The guilt is this one:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7d50b60b5e38f910ad69f0187af00f5d6a8970d4
> 
> It implements PMP support. In attached patch, I
> disable PMP support in ahci.c to SiS SATA controllers.
> 
> I hope i am sending the patch to correct place and
> it works fine to others (well, it's working to me).

This change made into the kernel in commit 9a3b103c...  Today, I
tested a SIS968 board whose lspci -nn output looks like the following.

  00:00.0 Host bridge [Class 0600]: Silicon Integrated Systems [SiS] 671MX [1039:0671]
  00:01.0 PCI bridge [Class 0604]: Silicon Integrated Systems [SiS] PCI-to-PCI bridge [1039:0004]
  00:02.0 ISA bridge [Class 0601]: Silicon Integrated Systems [SiS] SiS968 [MuTIOL Media IO] [1039:0968] (rev 01)
  00:02.5 IDE interface [Class 0101]: Silicon Integrated Systems [SiS] 5513 [IDE] [1039:5513] (rev 01)
  00:03.0 USB Controller [Class 0c03]: Silicon Integrated Systems [SiS] USB 1.0 Controller [1039:7001] (rev 0f)
  00:03.1 USB Controller [Class 0c03]: Silicon Integrated Systems [SiS] USB 1.0 Controller [1039:7001] (rev 0f)
  00:03.3 USB Controller [Class 0c03]: Silicon Integrated Systems [SiS] USB 2.0 Controller [1039:7002]
  00:04.0 Ethernet controller [Class 0200]: Silicon Integrated Systems [SiS] 191 Gigabit Ethernet Adapter [1039:0191] (rev 02)
  00:05.0 SATA controller [Class 0106]: Silicon Integrated Systems [SiS] AHCI IDE Controller (0106) [1039:1185] (rev 03)
  00:06.0 PCI bridge [Class 0604]: Silicon Integrated Systems [SiS] PCI-to-PCI bridge [1039:000a]
  00:07.0 PCI bridge [Class 0604]: Silicon Integrated Systems [SiS] PCI-to-PCI bridge [1039:000a]
  00:0d.0 VGA compatible controller [Class 0300]: ATI Technologies Inc Radeon RV100 QZ [Radeon 7000/VE] [1002:515a]
  00:0f.0 Audio device [Class 0403]: Silicon Integrated Systems [SiS] Azalia Audio Controller [1039:7502]
  00:10.0 RAID bus controller [Class 0104]: HighPoint Technologies, Inc. HPT372A/372N [1103:0005] (rev 02)
  02:00.0 Ethernet controller [Class 0200]: Intel Corporation 82572EI Gigabit Ethernet Controller (Copper) [8086:10b9] (rev 06)

And the AHCI controller 1039:1185 @ 00:05.0 works just fine with
regular devices and PMPs.  Can you please post lspci -nn output on
your machine?  It seems the blacklisting was too wide.

Thanks.

-- 
tejun
