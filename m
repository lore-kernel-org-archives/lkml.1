Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbYG3JKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbYG3JKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYG3JKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:10:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752755AbYG3JKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:10:20 -0400
Date: Wed, 30 Jul 2008 02:08:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: [BUG] wireless : cpu stuck for 61s
Message-Id: <20080730020820.8bcc00e2.akpm@linux-foundation.org>
In-Reply-To: <1217334724.10489.47.camel@johannes.berg>
References: <20080729055731.GA3265@darkstar>
	<1217334724.10489.47.camel@johannes.berg>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 14:32:04 +0200 Johannes Berg <johannes@sipsolutions.net> wrote:

> On Tue, 2008-07-29 at 13:57 +0800, Dave Young wrote:
> > While set my wlan0 to ad-hoc mode and then set the essid to something,
> > this bug triggered.
> > 
> > I suspect it's related to debugfs or mutex? But I'm not sure.
> > 
> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493] BUG: soft lockup - CPU#0 stuck for 61s! [events/0:9]
> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493] 
> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493] Pid: 9, comm: events/0 Tainted: G        W (2.6.26-smp #3)
> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493] EIP: 0060:[<c0450bc3>] EFLAGS: 00000246 CPU: 0
> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493] EIP is at mutex_lock_nested+0x1b3/0x280
> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493] EAX: 00000000 EBX: f7bf5284 ECX: f7c7e000 EDX: f7bf52a8
> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493] ESI: f7bf5288 EDI: 00000246 EBP: f7c7fedc ESP: f7c7fe9c
> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493] CR0: 8005003b CR2: b800c5ac CR3: 36e71000 CR4: 000006d0
> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493] DR6: ffff0ff0 DR7: 00000400
> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  [<c02375a6>] ? debugfs_create_file+0x46/0x210
> 
> It looks like it's getting stuck on
> mutex_lock(&parent->d_inode->i_mutex);
> 
> inside debugfs_create_by_name, but I have no idea why that would happen.
> 

Dave, please try sysrq-W or sysrq-T during that 60 seconds, see if we
can find another task which is holding onto that lock.

