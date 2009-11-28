Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZK1Uig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZK1Uig (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 15:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbZK1Uif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 15:38:35 -0500
Received: from cnc.isely.net ([64.81.146.143]:45301 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbZK1Uif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 15:38:35 -0500
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Nov 2009 15:38:34 EST
Date: Sat, 28 Nov 2009 14:33:30 -0600 (CST)
From: Mike Isely <isely@isely.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-media@vger.kernel.org
Subject: Re: [GIT PULL for 2.6.32] V4L/DVB updates
In-Reply-To: <200911280357.58116.hverkuil@xs4all.nl>
Message-ID: <alpine.DEB.1.10.0911281425240.5482@ivanova.isely.net>
References: <4B103CE1.8050303@redhat.com> <200911272240.02930.s.L-H@gmx.de> <200911280357.58116.hverkuil@xs4all.nl>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Nov 2009, Hans Verkuil wrote:

> On Friday 27 November 2009 22:40:01 Stefan Lippers-Hollmann wrote:
> > Hi
> > 
> > On Friday 27 November 2009, Mauro Carvalho Chehab wrote:
> > > Hi Linus,
> > > 
> > > Please pull from:
> > >         ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus
> > > 
> > > For the following drivers and building fixes:
> > > 
> > >    - radio-gemtek-pci: fix double mutex_lock
> > >    - v4l: add more missing linux/sched.h includes
> > >    - soc-camera: properly initialise the device object when reusing
> > >    - soc-camera: sh_mobile_ceu_camera: call pm_runtime_disable
> > >    - em28xx: fix Reddo DVB-C USB TV Box GPIO
> > >    - davinci: remove stray duplicate config pointer
> > >    - SMS_SIANO_MDTV should depend on HAS_DMA
> > >    - cxusb: Fix hang on DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1)
> > >    - sh_mobile_ceu_camera: fix compile warning
> > >    - Fix wrong parameter order in memset
> > [...]
> > 
> > Please consider cherry picking the following two patches from Hans 
> > Verkuil [1]:
> > - add the missing s2250-loader.h
> > - s2250 mutex patch	
> 
> Good catch. Mauro, can you please add these two as well for 2.6.32? I'm sure
> I marked these two as high-prio patches. This staging driver is actively
> being used and developed so this regression should be fixed.
> 

Mauro:

I had also posted up two high priority pvrusb2 patches that should 
really be cherry-picked for 2.6.32.  You've already pulled them into 
v4l/dvb and I did mark them as high priority at the time.

These patches enable use of FX2 microcontroller firmware that is 16KB in 
size.  Hauppauge is no longer shipping 8KB firmware for HVR-1950 and 
HVR-1900 and without these changes then those devices won't work AT ALL 
in kernel 2.6.32.

You can find these within the v4l-dvb Mercurial repository here:

Changeset 13495:87c3853fe2b3 
Subject: pvrusb2: Support 16KB FX2 firmware
http://linuxtv.org/hg/v4l-dvb/rev/87c3853fe2b3

Changeset 13500:d4c418d4b25c
Subject: pvrusb2: Fix lingering 16KB FX2 Firmware issues
http://linuxtv.org/hg/v4l-dvb/rev/d4c418d4b25c

I do not believe these patches have any ordering dependencies with other 
patches, though between the two the second one technically should come 
after the first.

Thanks,

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
