Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab0BOHaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 02:30:55 -0500
Received: from troy.hostgo.com ([64.62.143.130]:40125 "EHLO troy.hostgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782Ab0BOHay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 02:30:54 -0500
From: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: oom killing kde erroneously (still)
Date: Sun, 14 Feb 2010 22:03:04 -0700
User-Agent: KMail/1.12.4 (Linux/2.6.32-trunk-amd64; KDE/4.3.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201002131658.24842.tfjellstrom@shaw.ca> <20100215094928.c1bbadeb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100215094928.c1bbadeb.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002142203.04405.tfjellstrom@strangesoft.net>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - troy.hostgo.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - strangesoft.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On February 14, 2010, KAMEZAWA Hiroyuki wrote:
> On Sat, 13 Feb 2010 16:58:24 -0700
> 
> Thomas Fjellstrom <tfjellstrom@shaw.ca> wrote:
> > For the past couple days I've been getting improper OOM Kills. It
> > decides to kill ksmserver, klauncher and kdeinit which takes down all
> > of kde, instead of whatever is having the actual problem.
> >
> > What I've been doing is copying files with rsync from my LAN's NFS
> > share, to a USB External HDD, and all the while I have things like
> > konversation (irc), kontact (email, rss, news), and firefox open doing
> > normal things with them. Without the rsync, I don't see these OOM
> > problems. But once I start a somewhat long running rsync process (tens
> > to hundreds of GB @ 40MB/s ish), kde will be killed after a while (not
> > usually very long, tens of minutes to a couple hours).
> >
> > This machine has 4 gigs of ram, runs 64bit kernel+apps, and while its
> > doing the rsync I have a CRAP load of free ram (minus file/disk cache,
> > at least half of my ram is free at the time it decides to oom kill
> > kde).
> >
> > here's my last log:
> >
> > [316981.060054] __ratelimit: 18 callbacks suppressed
> > [316981.060057] Xorg invoked oom-killer: gfp_mask=0x0, order=0,
> > oom_adj=0 [316981.060061] Xorg cpuset=/ mems_allowed=0
> > [316981.060063] Pid: 30074, comm: Xorg Not tainted 2.6.32-trunk-amd64
> > #1 [316981.060065] Call Trace:
> > [316981.060071]  [<ffffffff810b4cf0>] ? oom_kill_process+0x7f/0x23f
> > [316981.060074]  [<ffffffff810b5214>] ? __out_of_memory+0x12a/0x141
> > [316981.060077]  [<ffffffff810b53f1>] ?
> > pagefault_out_of_memory+0x54/0x7f [316981.060080]  [<ffffffff81032532>]
> > ? mm_fault_error+0x39/0xe6 [316981.060084]  [<ffffffff810f8004>] ?
> > do_vfs_ioctl+0x48d/0x4cb [316981.060086]  [<ffffffff81032845>] ?
> > do_page_fault+0x266/0x282 [316981.060090]  [<ffffffff812e6f25>] ?
> > page_fault+0x25/0x30
> 
> If you use i915, please check this bugzilla.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=14933
> 
> patch is this.
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit
> ;h=4bdadb9785696439c6e2b3efe34aa76df1149c83
> 
> Thanks,
> -Kame
> 

Ah, thanks for the heads up :) have to wait till debian gets the update 
though. At least I only seem to see that problem under specific 
circumstances, which don't happen frequently (copying a lot of files to my 
external hdd from an nfs share).

-- 
Thomas Fjellstrom
tfjellstrom@strangesoft.net
