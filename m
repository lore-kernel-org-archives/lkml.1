Return-Path: <linux-kernel-owner+w=401wt.eu-S1763378AbYDYQG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763378AbYDYQG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 12:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757359AbYDYQGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 12:06:20 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:19923 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453AbYDYQGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 12:06:19 -0400
Date: Fri, 25 Apr 2008 09:04:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "werner" <werner@copaya.yi.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: EDD problem -- regression -- crash on booting by probing EDD
Message-Id: <20080425090441.27d8e90b.randy.dunlap@oracle.com>
In-Reply-To: <1208910044.20701@copaya.yi.org>
References: <20080422142103.GA5652@auslistsprd01.us.dell.com>
	<1208910044.20701@copaya.yi.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2008 21:20:44 -0300 (GFT) werner wrote:

> As I tested yesterday extensively, the problem wasn't present at 2.6.24-rc5-git6 (SYS Linux 0.17 install DVD) nor at 2.6.24-rc6-git2 (SYS 0.19) ,  but at 2.6.24-rc6-git8 (SYS 0.20-rc1 and 0.20-rc2) and 2.6.25 (0.21-r3).
> 
> The whole compiled packages of these kernels still are at copaya.yi.org/tgz , but I extracted  the important parts, see enclosed here.    The .tar.bz2 file contains  the config  and the protocoll of the compilation (inclusive warning / error messages). 
> 
> As you can see, the diff between the config of 2.6.24-rc6-git2 and -git8 is nothing.  That means: THE ERROR ENTERED INTO THE KERNEL BETWEEN THESE TWO GITs !!      
> 
> You may also analyze the error/warning messages. Please observe that the error message just at the beginning was already subject of another reclamation mine together with another person, and seems to have be corrected.
> 
> I inform still about the following:    As I make many experients and also install Linux often for firnds and neighbours, I see steady-steady some kernel errors, but have normally no time to track them, in the house of the persons.  That error here, I saw already several times, and never it helped the edd=off option.    Yesterday it happened that a friend brought a laptop (ACER Aspire 7004WSMi) to me, after he was unsuccessfull to install  SYS 0.21-r3 dvd with 2.6.25-rc7 . Then I tracked that problem during about 5 hours, inclusively trying a lot of different kernel options.  edd=off don't work at all, with no of the affected kernels.  With 2.6.24-rc6-git2 and earlier kernels the problem didnt appear, even without edd=off option, and with the later kernels it appears, even with edd=off .    With pci=off , also the recent kernels boots -- but this is useless because the system don't find any hard disk.  acpi=off or hwprobe=off have no influence on that problem.
> 
> Pls search that error and repair it !
> **********  YOU SHOULD MAKE AN EXTRA KERNEL OPTION, WHAT IGNORES THE HARDWARE AND CONTINUES TO BOOT, like pci=off,  BUT WHAT DETECTS CD ROMS, HARD DISKS SATA / IDE / RAID , AND WHAT PERMITS TO USE THE COMPUTER NORMALLY AT LEAST IN VESA-FB OR FBDEV MODE !!!!! *************
> 
> As there has no other solution, I released last night SYS 0.21-r4 DVD , what contains both, the 2.6.25 , and alternatively 2.6.24-rc6-git2 , so that people can use them computer anyway / anyhow :    ftp://ftp5.gwdg.de/pub/linux/install/sys/  
> 
> I can put the suggested debug, generally, in the kernel command line of my SYS install DVD. However, the person gone with his laptop so that at the moment I cannot test it; I have to wait if the same problem occurs on another computer.  

We need that initcall_debug information.  And it would be helpful
to have a list of hardware that is installed on the problem system:
lspci -v


> Werner Landgraf
> 
> Linux  SYS   
> 
> http://linux.softpedia.com/get/System/Operating-Systems/Linux-Distributions/SYS-34168.shtml
>  
> 
> 
> annexed: 1 file
> ======================================================================================
> On 22/Abr/2008 11:21 Matt Domsch wrote ..
> > On Tue, Apr 22, 2008 at 06:28:40AM -0700, Andrew Morton wrote:
> > > > On Sun, 20 Apr 2008 19:33:32 -0300 (GFT) "werner" <werner@copaya.yi.org> wrote:
> > > > There is a regression in 2.6.25.
> > > 
> > > Rafael bcc'ed.
> > > 
> > > >   Booting stops with: Probing EDD (edd=off to disable) message.
> > > > 
> > > > It dont work the kernel boot parameter edd=off .  With pci=off the computer
> > continues to boot, but later it dont find hard disks etc.
> > > 
> > > Tim and Matt cc'ed.
> > > 
> > > > Thats happening on 2.6.25   definitive, but was verified to go back until 2.6.24-rc6-git8,
> > but it wasnt yet at 2.6.24-rc6-git2 which worked correctly.
> > > > 
> > > 
> > > hm, that's a nice narrow window.  Unfortunately for the next few days I
> > > can't personally get in and find out what we changed during it.
> > 
> > I've scanned the diff between these, and can't see anything that would
> > obviously cause a problem.  Nothing that touches the EDD codepath
> > directly at least.  I'll be curious to see the additional initcall
> > debug data.
> > 
> > -- 
> > Matt Domsch
> > Linux Technology Strategist, Dell Office of the CTO
> > linux.dell.com & www.dell.com/linux
> 


---
~Randy
