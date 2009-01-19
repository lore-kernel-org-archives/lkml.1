Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbZASViM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbZASViM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbZASVhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:37:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39761 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688AbZASVhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:37:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: etienne <etienne.basset@numericable.fr>
Subject: Re: [2.6.29-rc2][Suspend regression][DRM ???? bisected]
Date: Mon, 19 Jan 2009 22:37:19 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org
References: <4971DFA5.2000304@numericable.fr> <4974EB02.4060303@numericable.fr>
In-Reply-To: <4974EB02.4060303@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901192237.19847.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2009, etienne wrote:
> Hello,
> 
> etienne wrote:
> > hello,
> >
> > With 2.6.29-rc2 (and rc1) i cannot resume from suspend to ram (echo 
> > mem > /sys/power/state). Computer correctly suspends, but never wakes 
> > up (screens stays black and everything is unresponsive)
> >                   
> > It has been working flawlessly in all prior kernel.
> > I tried a bisection and it "seems" to point to :
> > ====================================
> > a9d51a5ad1154b5b20add1e8d30a5564f8aabbe9 is first bad commit
> > commit a9d51a5ad1154b5b20add1e8d30a5564f8aabbe9            Author: 
> > Dave Airlie <airlied@linux.ie>                     Date:   Sun Dec 7 
> > 12:02:21 2008 +1000                     
> >    drm: reorganise start and load.
> >                                     Make sure we have the primary node 
> > so the device can add maps.
> >                                                                    
> > Signed-off-by: Dave Airlie <airlied@redhat.com>              
> > ========================================
> >
> > HOWEVER, I am not quite sure my bisect was correct; I mean, some "bad 
> > bisect" had a different behavior (resume produces  a garbage screen, 
> > computer locked)
> > and after bisect 57a6297e52b32ff402291a7d8fd802f83e746e52 all "bad" 
> > kernel wouldn't start X, init=/bin/bash booted fine but no resume
> >
> > I tried  to revert but got errors
> > =============================
> > etienne@etienne-desktop:~/linux-2.6$ git revert  
> > a9d51a5ad1154b5b20add1e8d30a5564f8aabbe9
> > warning: too many files, skipping inexact rename detection
> > Auto-merged drivers/gpu/drm/drm_stub.c
> > CONFLICT (content): Merge conflict in drivers/gpu/drm/drm_stub.c
> > Automatic revert failed.  After resolving the conflicts,
> > mark the corrected paths with 'git add <paths>' or 'git rm <paths>' 
> > and commit the result.
> > =========================
> > Please find attached bisect log, lspci (from 2.6.28-rc8) , and .config 
> > (2.6.29rc2)
> >
> > I have a radeon card
> > 01:00.0 VGA compatible controller: ATI Technologies Inc RV370 5B60 
> > [Radeon X300(PCIE)]
> > Packages :
> > xserver-xorg-video-radeon            
> > 1:6.9.0+git20081003.f9826a56-0ubuntu2.1
> > ii  xserver-xorg                              
> > 1:7.4~5ubuntu3                              the X.Org X 
> > server                                                   ii  
> > xserver-xorg-core                         
> > 2:1.5.2-2ubuntu3                            Xorg X server - core 
> > server                  
> > I'm willing to test patches and ideas of course :)
> >
> > Except for this regression, everything works fine for me, I migrated 
> > to ext4 and it "feels" a huge win especially on "rm" and fsck :))
> >
> > best regards,
> > Etienne
> >
> >
> >
> hello,
> 
> as my bisect directed to drm but as I was unable to revert the commit, I 
> took my 2.6.29rc2 kernel,  removed drivers/gpu/drm and include/drm and 
> replaced them  with 2.6.28 files.
> Rebooted into this new kernel, suspended to ram and ...same bug :(
> so maybe there a bug in drm, but there another one elsewhere...
> I checked /var/log/messages from a working and a non working kernel, and 
> there's absolutely _nothing_ in non-working kernels
> in working kernel i see suspend beginning like this :
> Jan 19 21:50:47 etienne-desktop kernel: PM: Syncing filesystems ... done.
> Jan 19 21:50:47 etienne-desktop kernel: [drm] Num pipes: 1
> 
> 
> Are there any patch i could try?

Actually, quite a few.

I'd recommend waiting until all of the known suspend regressions are fixed.

Thanks,
Rafael
