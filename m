Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbYJEVNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbYJEVNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 17:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbYJEVNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 17:13:10 -0400
Received: from iron02.fraunhofer.de ([153.96.1.56]:4226 "EHLO
	iron02.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbYJEVNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 17:13:10 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Oct 2008 17:13:09 EDT
Date: Sun, 05 Oct 2008 23:03:07 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: loki_val@gentoo.org, linux-kernel@vger.kernel.org
Cc: joerg.schilling@fokus.fraunhofer.de
Subject: Re: SATA Burner Pioneer DVR-216-DBK won't burn
Message-ID: <48e92b8b.h0rDl7oCw9ywhLoV%Joerg.Schilling@fokus.fraunhofer.de>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Oct 2008 21:03:11.0223 (UTC) FILETIME=[C6641870:01C9272D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[please CC me on replies]

>Linux loki 2.6.27-rc8 #5 SMP PREEMPT Sun Oct 5 17:56:00 CEST 2008 x86_64
>Intel(R) Core(TM)2 Quad CPU Q9550 @ 2.83GHz GenuineIntel GNU/Linux

>I recently acquired a DVR-216-DBK Pioneer SATA burner. With my old
>burner, a DVR-110D,  I am able to burn a DVD. With the DVR-216DBK, I'm
>not, it stops always at 98%, no matter which speed I burn at.

>My motherboard is a ASUS P5Q-EM, I have 8GB of ram and am running Gentoo
>Linux. I've tried both cdrkit and cdrtools.
>DVR-216-DBK Fails, connected to ICH10R AHCI SATA controller
>DVR-110D Succeeds, connected to Marvell 6101 PATA_MARVELL controller

First a note on your mkisofs command: you should not use the option
"-no-cache-inodes" unless you have a _really_ good reason and I am really sure 
that you don't have a reason ;-) mkisofs works best if you omit this option!

Regarding your write problems. From your mail, it is obvious that you did not 
try cdrecord but you used only the original mkisofs together with growisofs
and you tried to use growisofs in a mode that it's author does not like.


I cannot recommend wodim, it is based on a 3 year old version of cdrecord and 
the original DVD support from cdrecord code has been replaced by half baken
play code by someone else. There is even no support for it since May 6th 2007.

I would recommend you to try cdrecord. The k3b people told me that k3b prefers
cdrecord if found.

Make sure that cdrecord is installed suid root.
If your have more than one drive, first call cdrecord -scanbus for the right
dev= parameter. If you only have one drive, just omit dev= from your command 
line.

In order to get help, you need to send some information:

1) the cdrecord -atip output to indicate the media manufacturer.
	Media from cheap manufacturers may cause problems.

2) the cdrecord -minfo output to indicate the state of the medium before
	the write process started

3) the cdrecord -dao -v xxx.iso output to see what happens

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/private/ ftp://ftp.berlios.de/pub/schily
