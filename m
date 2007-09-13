Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbXIMJR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbXIMJR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbXIMJRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:17:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:20633 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbXIMJRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:17:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ZxQ9X2lXYWJCFwCa5MbpCywvx0Od147JcyniBc54SPhSypiHXEPgkImk76pW0oJe9nKJ3VXShumGqSQGrqwVPmXVRmBzG5JRqX8B8dBcH79+v2GbyhelUNxQ4HAeP/d2n0f+q40poEASDRiJG3RRXedPrvxxCbSEpauYlse7RMc=
Message-ID: <46E8FFD2.5010001@gmail.com>
Date: Thu, 13 Sep 2007 11:16:02 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jon Ivar Rykkelid <jonry@pvv.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv issues with MCP51 SATA controller
References: <46E8E440.10601@pvv.org>
In-Reply-To: <46E8E440.10601@pvv.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Ivar Rykkelid wrote:
> I'm having serious disk-issues when using the on-board nvidia controller
> for my HDDs (My motherboard is a Gigabyte GA-N650SLI-DS4 with nvidia
> chipset, cpu is intel Core2Quad)
> 
> excerpt from "lspci":
> 00:0d.0 IDE interface: nVidia Corporation MCP51 IDE (rev a1)
> 00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller
> (rev a1)
> 00:0f.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller
> (rev a1)
> 
> I have a normal IDE/P-ATA-disk attached to the "IDE"-controller and that
> works fine (/dev/hda)
> 
> However, any number of disks (I have tried 2 and 4) connected to the
> SATA-controller(s), will eventually fail. - See attached log (excerpt /
> anything relevant from /var/log/messages)
> 
> At first, disks were REALLY unstable, but then I disabled S.M.A.R.T.
> (both in BIOS and Linux), and I updated from the CentOS5 (equivalent of
> RHEL5) kernel (2.6.18) to the latest (at that time) official kernel form
> kernel.org:
> 
>> uname -a
> Linux mirakel 2.6.22.5-custom_jir #2 SMP Thu Aug 30 22:06:21 CEST 2007
> i686 i686 i386 GNU/Linux
> 
> Now it will normally take a day or two before SATA crashes, so things
> are better, but still rather useless.
> 
> First error when sata_nv get into problems is always:
> "exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen"
> (as shown in the attached log-file.) - when this happens to one device,
> it'll almost instantly happen to the other disk attached to that
> controller as well. A couple of minutes (or so) later, the disk(s)
> connected to the other controller will start acting up as well (in the
> same manner). - I/O freezes, and nothing helps except a reboot...
> 
> As I run a rather large (software / md) RAID-5 disk array on this server
> (I'm doing a bit of video editing), every crash means a time-consuming
> rebuild of the disk-array...
> 
> I have given up on the sata_nv / nvidia-controllers for the time being.
> I now resort to some old PCI-connected sata-controllers which work fine
> (but slow, as they are outdated and "overloaded").
> 
> So, if anyone has a good solution / suggestion / improved driver (over
> the one supplied with the official 2.6.22.5-kernel) I am eager to give
> it a go and see if the situation can be resolved.
> 
> I appreciate any sensible suggestions.

Wheeee... the whole controller seems to have went down at once and it's
not even IRQ routing problem - resets are failing.  This is the first
time I see something like this.  Sorry but I don't have any idea what's
going on.  cc'ing Robert.  Any ideas?

-- 
tejun
