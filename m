Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbZIXJBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbZIXJBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 05:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbZIXJBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 05:01:23 -0400
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:21896 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752426AbZIXJBV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 05:01:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Reply-To:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding;
  b=KH7fXqzxsoiSghek0FPLfmmFNigD4nggmwa3BTC6OrIMUwqeyHLOGzxk5R5PnIHFVLiiBk6Y6fERI5roayfGeFn/FY++RHWYLxhtjdKuf1Vo4n6adKICdy78G3abBHYFHMRNSX4hoJItL2J2q288Ewxwl15cBe9r3c66b2HwDQY=  ;
X-YMail-OSG: hzkwB40VM1mlbTQkHeufLejr51V5m817GN2LggFGK5ckkME6YbkV8wmdDoUrJz5a5POzbwKC.xR67iNlBa3nXUESzApEENcbA5.SM4i_qRkPNEZin1ilX1lFdI4xAI_O8_1xw5rLTyaqHGLeVpQ82dcl0L8Ra0_0t_brxRtGYWfR8njyIKAuodnLb.l7Aqsk6AT6gGyY.ke.klLjJTSGmXy6dbDw8MVFx4Jmi8HfEexVIif90grPxiOmTydHTQmiSbOoFmCrDroNC8RG8r2h7R.jReRTZAKeU9UM8kyLRbu2fGLPNpd4XSOfFxJnYSLCdtgjGYV.TvtFgxc-
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 24 Sep 2009 04:01:11 -0500
From: Will <whansard@sbcglobal.net>
To: odie@cs.aau.dk
Cc: linux-kernel@vger.kernel.org
Subject: Re: disk speed regression kernel 2.6.29 and after
Message-Id: <20090924040111.6d8203d5.whansard@sbcglobal.net>
In-Reply-To: <20090924094447.16137esujpct2bfz@webmail.cs.aau.dk>
References: <4ABA0FDA.9090707@sbcglobal.net>
	<4ABAE271.80309@gmail.com>
	<20090923233505.a567667b.whansard@sbcglobal.net>
	<20090924094447.16137esujpct2bfz@webmail.cs.aau.dk>
Reply-To: whansard@sbcglobal.net
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.13; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 09:44:47 +0200
odie@cs.aau.dk wrote:

> (Bart, a commit by you might be involved here, please see below.)
> 
> >> I had been using an old 2.6.22 kernel on my machine, and I often backup
> >> one partition of my main hard drive to a partition on a second hard
> >> drive. The main hard drive is sata 640 gigs, and the second is a pata
> >> 320 gig. copying this partition from one drive to the other with dd
> >> takes about 3 minutes and 30 seconds. When I installed kernel 2.6.30,
> >> and 2.6.31, the time took 9 minutes and 20 seconds. I decided to go to
> >> the trouble of compiling all the kernels between, and kernels
> >> 2.6.22-2.6.28 all do the operation in about 3 minutes and 30 seconds.
> >> 2.6.29- newer all take about 9 minutes and 20 seconds. The partition is
> >> 16 gigs. each drive seems to be as fast as before otherwise, it's just
> >> much slower copying from one drive to another, which I do very often.
> >> This is an nforce 3 based motherboard, amd southbridge, i think, with 4
> >> gigs of ram, athlon 64x2. 32 bit kernel. has anyone heard of this problem?
> >> I currently have 3 hard drives hooked up.
> >> a 200 gig on a promise controller,
> >> a 320 gig on the amd pata?
> >> a 640 sata on the nv i think.
> >> The motherboard is a Asrock-AM2NF3-VSTA
> >> copying this partition with dd or cat or schily's dd between any of these 3
> >> different hard drives takes different times depending on the speed of
> >> the drive with
> >> kernels 2.6.22-2.6.28, but takes about 9 minutes and 30 seconds on any
> >> of the drives
> >> with the kernels 2.6.29 and after.
> 
> >> Can you post the dmesg output from bootup on both the good and bad kernels?
> 
> So, the good and bad below are a result of a git bisect run?
> 
> And did you notice these warnings?
> 
> > good
> > Linux version 2.6.28-04985-gebdab07 (root@Wil.com) (gcc version  
> > 4.4.1 (GCC) ) #14 SMP Wed Sep 23 21:12:50 CDT 2009
> [...]
> 
> > Freeing unused kernel memory: 284k freed
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: sda5: warning: vs-500: unknown uniqueness -107167201[18060  
> > 33348 0xf6c5325c UNKNOWN] not found
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: sda5: warning: vs-500: unknown uniqueness -107167201[18060  
> > 113891 0xf6c55758 UNKNOWN] not found
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: sda5: warning: vs-500: unknown uniqueness  
> > -107167201[117144 365484 0xf6c56188 UNKNOWN] not found
> 
> Hmm, this looks like a reiserfs problem that was present for a while between
> 2.6.28 and 2.6.29-rc1 [1]. You'd probably like to run fsck.

the reiserfs warnings happened in the middle of the git run and after.
I made a backup before the git bisect run, so I'll probably just restore that.
I was getting the same results ( 3m30 seconds dd vs. 9m20 seconds) last
week when I ran that filesystem for a while as ocfs2, and then reiser4 for
a few days.  I can put whatever filesystem necessary.  I actually put reiser3
on that partition just for the git run, because I didn't want to have the 
reiser4 patch affect the results.



> 
> > ip_tables: (C) 2000-2006 Netfilter Core Team
> > hdb: UDMA/33 mode selected
> > ------------[ cut here ]------------
> > WARNING: at fs/sysfs/dir.c:462 sysfs_add_one+0x3c/0x50()
> > Hardware name: To Be Filled By O.E.M.
> > sysfs: duplicate filename 'audio' can not be created
> > Modules linked in: sound(+) ipt_LOG ip_tables x_tables
> > Pid: 1666, comm: modprobe Not tainted 2.6.28-04985-gebdab07 #14
> > Call Trace:
> >  [<c01406b2>] warn_slowpath+0x82/0xc0
> >  [<c050a8fe>] schedule+0x21e/0x780
> >  [<c012eb77>] xapic_wait_icr_idle+0x17/0x20
> >  [<c035ca84>] idr_get_empty_slot+0xe4/0x260
> >  [<c035cc79>] ida_get_new_above+0x79/0x1b0
> >  [<c01cfcd0>] sysfs_ilookup_test+0x0/0x10
> >  [<c01cfff1>] sysfs_find_dirent+0x21/0x30
> >  [<c01d012d>] __sysfs_add_one+0x1d/0xe0
> >  [<c019e8a6>] ilookup5+0x36/0x40
> >  [<c01d022c>] sysfs_add_one+0x3c/0x50
> >  [<c01d07d8>] create_dir+0x48/0x90
> >  [<c01d0849>] sysfs_create_dir+0x29/0x40
> >  [<c035d75f>] kobject_get+0xf/0x20
> >  [<c035d853>] kobject_add_internal+0x83/0x1d0
> >  [<c035da2a>] kobject_set_name_vargs+0x3a/0x50
> >  [<c035da5e>] kobject_add_varg+0x1e/0x60
> >  [<c035dafd>] kobject_add+0x2d/0x60
> >  [<c035d75f>] kobject_get+0xf/0x20
> >  [<c03c9a0a>] device_add+0xca/0x600
> >  [<c035d515>] kobject_init+0x25/0xa0
> >  [<c03c9fdb>] device_create_vargs+0x8b/0xd0
> >  [<c03ca04b>] device_create+0x2b/0x30
> >  [<f85ff0a5>] oss_init+0xa5/0x149 [sound]
> >  [<c0101123>] do_one_initcall+0x33/0x170
> >  [<f85ff000>] oss_init+0x0/0x149 [sound]
> >  [<c016345b>] sys_init_module+0x8b/0x1b0
> >  [<c018b688>] sys_close+0x58/0x90
> >  [<c011c26e>] syscall_call+0x7/0xb
> > ---[ end trace c45370bb6aa94452 ]---
> > kobject_add_internal failed for audio with -EEXIST, don't try to  
> > register things with the same name in the same directory.
> > Pid: 1666, comm: modprobe Tainted: G        W  2.6.28-04985-gebdab07 #14
> > Call Trace:
> >  [<c035d902>] kobject_add_internal+0x132/0x1d0
> >  [<c035dafd>] kobject_add+0x2d/0x60
> >  [<c035d75f>] kobject_get+0xf/0x20
> >  [<c03c9a0a>] device_add+0xca/0x600
> >  [<c035d515>] kobject_init+0x25/0xa0
> >  [<c03c9fdb>] device_create_vargs+0x8b/0xd0
> >  [<c03ca04b>] device_create+0x2b/0x30
> >  [<f85ff0a5>] oss_init+0xa5/0x149 [sound]
> >  [<c0101123>] do_one_initcall+0x33/0x170
> >  [<f85ff000>] oss_init+0x0/0x149 [sound]
> >  [<c016345b>] sys_init_module+0x8b/0x1b0
> >  [<c018b688>] sys_close+0x58/0x90
> >  [<c011c26e>] syscall_call+0x7/0xb
> > hdc: UDMA/33 mode selected
> > Driver 'sr' needs updating - please use bus_type methods
> > hdd: UDMA/66 mode selected
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: warning: vs-500: unknown uniqueness -1071672013
> > ReiserFS: sda5: warning: vs-500: unknown uniqueness  
> > -107167201[117144 365494 0xf6ca87d8 UNKNOWN] not found
> > w83627ehf: Found W83627EHG chip at 0x290
> > warning: process `update' used the obsolete bdflush system call
> > Fix your initscripts?
> > warning: process `update' used the obsolete bdflush system call
> > Fix your initscripts?
> 
> These warnings are a consequence of the problem above I believe. I don't
> know whether they have affected your bisect run, you should really apply
> the patch in [1] and rerun the tests.
> 
> >
> > bad
> >
> > Linux version 2.6.28-04986-g295f000 (root@Wil.com) (gcc version  
> > 4.4.1 (GCC) ) #13 SMP Wed Sep 23 21:08:03 CDT 2009
> 
> So if your bisect is correct, then 295f000
> (ide: don't execute the next queued command from the hard-IRQ context (v2))
> is faulty.
> 
> Bart, any ideas or would you like a rerun with the reiserfs patch in place
> by Will?
> 
> [1] http://lkml.org/lkml/2009/1/12/471
> 
> 
> Simon Holm Thøgersen
> 
> ----------------------------------------------------------------
> This message was sent using IMP, the Internet Messaging Program.
> 


-- 
