Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654AbXC3Lb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbXC3Lb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 07:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbXC3Lb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 07:31:29 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:59296 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbXC3Lb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 07:31:28 -0400
X-Greylist: delayed 794 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Mar 2007 07:31:28 EDT
Date: Fri, 30 Mar 2007 13:17:44 +0200
From: Eduard Bloch <edi@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: debburn-devel@lists.alioth.debian.org
Subject: broken device locking, sg vs. sg_io on block devices
Message-ID: <20070330111744.GA8889@rotes76.wohnheim.uni-kl.de>
References: <200703261811.21448.gerald@itzgrund.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703261811.21448.gerald@itzgrund.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am talking this issue to LKML now.

Short story: using O_EXCL on /dev/srX alone does not help to prevent
other process from killing your burn process by just reading the
/dev/sgX device associated with yours, and vice versa. We have done the
best we could to make safe operation (in contrary to Schilling's
kill-this-evil-hald-thing bitching) but that is not enough, the locking
has to be established on kernel layer.

Long story:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=413960
https://bugzilla.novell.com/show_bug.cgi?id=226019
http://lists.alioth.debian.org/pipermail/debburn-devel/2007-February/000297.html
and other error messages.

There is AFAICS no simple way to establish locking across the driver
borders. If kernel developers have a good idea, any help is appreciated.

Below are the typical symptoms: wodim operates via /dev/sgX because the
user chosen it this way, some other process (most likely hald) comes
along and reads from /dev/sr0 and the drive gets confused. Boom.

Regards,
Eduard.

* Gerald Lutter [Mon, Mar 26 2007, 06:10:44PM]:
> Hello List,
> 
> i've tried to burn the grml_0.9.iso to a cdr/cd-rw medium using wodim from 
> cdrkit 1.1.2 and the burner HL-DT-ST GMA-4082N. The iso can be fetched 
> >from "http://www.grml.org".
> 
> To make a long story short, burning this image to dvd+r and dvd+rw media works 
> without any problems but I need this image on a cdr or cd-rw medium. I've 
> attatched the output of the command I used to this mail:
> 
> /usr/bin/wodim -vvv -VVV gracetime=2 dev=2,0,0 speed=10 
                                       ^^^^^^^^^
> driveropts=burnfree -eject -overburn -data /tmp/grml_0.9.iso
...
> 
Track 01:    0 of  692 MB written.
> write track data: error after 317440 bytes
...
> Sense Key: 0x2 Not Ready, Segment 0
> Sense Code: 0x04 Qual 0x08 (logical unit not ready, long write in progress) Fru 0x0
> Sense flags: Blk 0 (not valid) 


-- 
* Amaya knuddelt Ganneff because of his email to private :*
<Ganneff> ich wusst doch dass die irgendwo was schlechtes nach sich zieht.
