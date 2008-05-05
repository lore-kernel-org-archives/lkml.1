Return-Path: <linux-kernel-owner+w=401wt.eu-S1758870AbYEENnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbYEENnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbYEENnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:43:33 -0400
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:45632 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754601AbYEENnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:43:32 -0400
Date: Mon, 5 May 2008 15:43:15 +0200
From: Enrico Weigelt <weigelt@metux.de>
To: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: VFS + path walktrough
Message-ID: <20080505134315.GF32019@nibiru.local>
Reply-To: weigelt@metux.de
References: <20080505124041.GB32019@nibiru.local> <20080505130623.GC32019@nibiru.local> <20080505131307.GM5882@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505131307.GM5882@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Al Viro <viro@ZenIV.linux.org.uk> wrote:
> On Mon, May 05, 2008 at 03:06:23PM +0200, Enrico Weigelt wrote:
> 
> > We could just add another call vector to struct file_operations,
> > as replacement for link_path_walk() - if it's zero, the original
> > function is used. This way an filesystem can do the walktrough
> > by it's own, but doesn't need to.
> > 
> > 
> > What do you think about this ?
> 
> That you have quite forgotten about mounts.  

hmm, I though this would be done before the link_path_walk() 
call happens ;-o

> And we *REALLY* don't want to shift the entire logics of 
> link_path_walk() into filesystems - this is insane. 

Only for those filesystems who *really* want to do it by 
themselves and set the appropriate call vector. All other 
fs'es will just leave it blank (even don't have to be touched)
and so the old way remains for them.

To get around mointpoint issues, we could at least do it only
when an special mount option is given and add an big-fat warning
that mountpoints within these mounts won't work. So these fast
lookups will only happen when:

#1: the fs explicitly supports it
#2: mounted with an special option

And if you use that option, you'll simply loose the ability
of using mointpoints within this specific mount. This won't 
affect any situation other than #1 && #2, IMHO this is better
than no chance of fast lookups at all. Of course, an cleaner
approach would be better, but it's IMHO not critical.

BTW: there are (or have been) certain speed improvements for 
specific situations w/ loosing other standard features, eg.
fast bridging.


cu
-- 
---------------------------------------------------------------------
 Enrico Weigelt    ==   metux IT service - http://www.metux.de/
---------------------------------------------------------------------
 Please visit the OpenSource QM Taskforce:
 	http://wiki.metux.de/public/OpenSource_QM_Taskforce
 Patches / Fixes for a lot dozens of packages in dozens of versions:
	http://patches.metux.de/
---------------------------------------------------------------------
