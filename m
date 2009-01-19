Return-Path: <linux-kernel-owner+w=401wt.eu-S1759443AbZASVF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbZASVF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbZASVFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:05:17 -0500
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:58189 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbZASVFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:05:16 -0500
Message-ID: <4974EB02.4060303@numericable.fr>
Date: Mon, 19 Jan 2009 22:05:06 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: airlied@linux.ie, rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: Re: [2.6.29-rc2][Suspend regression][DRM ???? bisected]
References: <4971DFA5.2000304@numericable.fr>
In-Reply-To: <4971DFA5.2000304@numericable.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

etienne wrote:
> hello,
>
> With 2.6.29-rc2 (and rc1) i cannot resume from suspend to ram (echo 
> mem > /sys/power/state). Computer correctly suspends, but never wakes 
> up (screens stays black and everything is unresponsive)
>                   
> It has been working flawlessly in all prior kernel.
> I tried a bisection and it "seems" to point to :
> ====================================
> a9d51a5ad1154b5b20add1e8d30a5564f8aabbe9 is first bad commit
> commit a9d51a5ad1154b5b20add1e8d30a5564f8aabbe9            Author: 
> Dave Airlie <airlied@linux.ie>                     Date:   Sun Dec 7 
> 12:02:21 2008 +1000                     
>    drm: reorganise start and load.
>                                     Make sure we have the primary node 
> so the device can add maps.
>                                                                    
> Signed-off-by: Dave Airlie <airlied@redhat.com>              
> ========================================
>
> HOWEVER, I am not quite sure my bisect was correct; I mean, some "bad 
> bisect" had a different behavior (resume produces  a garbage screen, 
> computer locked)
> and after bisect 57a6297e52b32ff402291a7d8fd802f83e746e52 all "bad" 
> kernel wouldn't start X, init=/bin/bash booted fine but no resume
>
> I tried  to revert but got errors
> =============================
> etienne@etienne-desktop:~/linux-2.6$ git revert  
> a9d51a5ad1154b5b20add1e8d30a5564f8aabbe9
> warning: too many files, skipping inexact rename detection
> Auto-merged drivers/gpu/drm/drm_stub.c
> CONFLICT (content): Merge conflict in drivers/gpu/drm/drm_stub.c
> Automatic revert failed.  After resolving the conflicts,
> mark the corrected paths with 'git add <paths>' or 'git rm <paths>' 
> and commit the result.
> =========================
> Please find attached bisect log, lspci (from 2.6.28-rc8) , and .config 
> (2.6.29rc2)
>
> I have a radeon card
> 01:00.0 VGA compatible controller: ATI Technologies Inc RV370 5B60 
> [Radeon X300(PCIE)]
> Packages :
> xserver-xorg-video-radeon            
> 1:6.9.0+git20081003.f9826a56-0ubuntu2.1
> ii  xserver-xorg                              
> 1:7.4~5ubuntu3                              the X.Org X 
> server                                                   ii  
> xserver-xorg-core                         
> 2:1.5.2-2ubuntu3                            Xorg X server - core 
> server                  
> I'm willing to test patches and ideas of course :)
>
> Except for this regression, everything works fine for me, I migrated 
> to ext4 and it "feels" a huge win especially on "rm" and fsck :))
>
> best regards,
> Etienne
>
>
>
hello,

as my bisect directed to drm but as I was unable to revert the commit, I 
took my 2.6.29rc2 kernel,  removed drivers/gpu/drm and include/drm and 
replaced them  with 2.6.28 files.
Rebooted into this new kernel, suspended to ram and ...same bug :(
so maybe there a bug in drm, but there another one elsewhere...
I checked /var/log/messages from a working and a non working kernel, and 
there's absolutely _nothing_ in non-working kernels
in working kernel i see suspend beginning like this :
Jan 19 21:50:47 etienne-desktop kernel: PM: Syncing filesystems ... done.
Jan 19 21:50:47 etienne-desktop kernel: [drm] Num pipes: 1


Are there any patch i could try?
Is it possible to run a git bisect excluding all drm commits to find the 
other bug?


regards
Etienne
