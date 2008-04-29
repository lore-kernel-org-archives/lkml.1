Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbYD2Vj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbYD2Vj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYD2VjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:39:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbYD2VjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:39:15 -0400
Date: Tue, 29 Apr 2008 14:38:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: harvey.harrison@gmail.com, rdunlap@xenotime.net, rmk+lkml@arm.linux.org.uk,
       bunk@kernel.org, den@openvz.org, linux-pcmcia@lists.infradead.org,
       adobriyan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: pcmcia_ioctl.c compile error
Message-Id: <20080429143824.8015c502.akpm@linux-foundation.org>
In-Reply-To: <20080429141520.7a778606.rdunlap@xenotime.net>
References: <20080429182709.GB2898@cs181133002.pp.htv.fi>
	<20080429201704.GA31311@flint.arm.linux.org.uk>
	<20080429135902.504b6362.rdunlap@xenotime.net>
	<1209502988.24729.31.camel@brick>
	<20080429140926.bb763630.akpm@linux-foundation.org>
	<20080429141520.7a778606.rdunlap@xenotime.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 14:15:20 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> > > I believe Russell is referring to the removal of the ioctl, not the
> > > compile breakage.
> > > 
> > 
> > That would be interesting information (although I have a vague feeling that
> > it has been discussed before).
> 
> Yes:  http://lkml.org/lkml/2008/2/27/291
> (now that Harvey reminded me/us)

oh, OK, whatever, that's easy.  I dropped the old patch and queued this
one:

--- a/Documentation/feature-removal-schedule.txt~x
+++ a/Documentation/feature-removal-schedule.txt
@@ -47,23 +47,6 @@ Who:	Mauro Carvalho Chehab <mchehab@infr
 
 ---------------------------
 
-What:	PCMCIA control ioctl (needed for pcmcia-cs [cardmgr, cardctl])
-When:	November 2005
-Files:	drivers/pcmcia/: pcmcia_ioctl.c
-Why:	With the 16-bit PCMCIA subsystem now behaving (almost) like a
-	normal hotpluggable bus, and with it using the default kernel
-	infrastructure (hotplug, driver core, sysfs) keeping the PCMCIA
-	control ioctl needed by cardmgr and cardctl from pcmcia-cs is
-	unnecessary, and makes further cleanups and integration of the
-	PCMCIA subsystem into the Linux kernel device driver model more
-	difficult. The features provided by cardmgr and cardctl are either
-	handled by the kernel itself now or are available in the new
-	pcmciautils package available at
-	http://kernel.org/pub/linux/utils/kernel/pcmcia/
-Who:	Dominik Brodowski <linux@brodo.de>
-
----------------------------
-
 What:	sys_sysctl
 When:	September 2010
 Option: CONFIG_SYSCTL_SYSCALL
_

