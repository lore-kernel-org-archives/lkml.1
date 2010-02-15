Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab0BOAw4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 19:52:56 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43760 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab0BOAwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 19:52:55 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 15 Feb 2010 09:49:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: oom killing kde erroneously (still)
Message-Id: <20100215094928.c1bbadeb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <201002131658.24842.tfjellstrom@shaw.ca>
References: <201002131658.24842.tfjellstrom@shaw.ca>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Feb 2010 16:58:24 -0700
Thomas Fjellstrom <tfjellstrom@shaw.ca> wrote:

> For the past couple days I've been getting improper OOM Kills. It decides to 
> kill ksmserver, klauncher and kdeinit which takes down all of kde, instead 
> of whatever is having the actual problem.
> 
> What I've been doing is copying files with rsync from my LAN's NFS share, to 
> a USB External HDD, and all the while I have things like konversation (irc), 
> kontact (email, rss, news), and firefox open doing normal things with them. 
> Without the rsync, I don't see these OOM problems. But once I start a 
> somewhat long running rsync process (tens to hundreds of GB @ 40MB/s ish), 
> kde will be killed after a while (not usually very long, tens of minutes to 
> a couple hours).
> 
> This machine has 4 gigs of ram, runs 64bit kernel+apps, and while its doing 
> the rsync I have a CRAP load of free ram (minus file/disk cache, at least 
> half of my ram is free at the time it decides to oom kill kde).
> 
> here's my last log:
> 
> [316981.060054] __ratelimit: 18 callbacks suppressed                                                                                                                                
> [316981.060057] Xorg invoked oom-killer: gfp_mask=0x0, order=0, oom_adj=0                                                                                                           
> [316981.060061] Xorg cpuset=/ mems_allowed=0                                                                                                                                        
> [316981.060063] Pid: 30074, comm: Xorg Not tainted 2.6.32-trunk-amd64 #1                                                                                                            
> [316981.060065] Call Trace:                                                                                                                                                         
> [316981.060071]  [<ffffffff810b4cf0>] ? oom_kill_process+0x7f/0x23f                                                                                                                 
> [316981.060074]  [<ffffffff810b5214>] ? __out_of_memory+0x12a/0x141                                                                                                                 
> [316981.060077]  [<ffffffff810b53f1>] ? pagefault_out_of_memory+0x54/0x7f                                                                                                           
> [316981.060080]  [<ffffffff81032532>] ? mm_fault_error+0x39/0xe6                                                                                                                    
> [316981.060084]  [<ffffffff810f8004>] ? do_vfs_ioctl+0x48d/0x4cb                                                                                                                    
> [316981.060086]  [<ffffffff81032845>] ? do_page_fault+0x266/0x282                                                                                                                   
> [316981.060090]  [<ffffffff812e6f25>] ? page_fault+0x25/0x30 

If you use i915, please check this bugzilla.

http://bugzilla.kernel.org/show_bug.cgi?id=14933

patch is this.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4bdadb9785696439c6e2b3efe34aa76df1149c83

Thanks,
-Kame

