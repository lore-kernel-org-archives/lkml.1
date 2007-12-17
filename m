Return-Path: <linux-kernel-owner+w=401wt.eu-S1762859AbXLQPcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762859AbXLQPcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 10:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbXLQPcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 10:32:31 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:40838 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbXLQPcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 10:32:31 -0500
Date: Mon, 17 Dec 2007 16:32:29 +0100
From: Jan Kara <jack@suse.cz>
To: Denis <denismpa@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fwd: NFS , Kjournald - status D (uninterruptible sleep) - maquina lenta.
Message-ID: <20071217153228.GC6979@atrey.karlin.mff.cuni.cz>
References: <e9aeeef80712141011i139e6ec2pe04250bd56f338d8@mail.gmail.com> <e9aeeef80712141211v7cec29fdt7e2ec76bf877053f@mail.gmail.com> <e9aeeef80712141333n557325e3v11231b8bbe1b0963@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9aeeef80712141333n557325e3v11231b8bbe1b0963@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Dears, I've got a double dual xeon wich sometimes is getting too slow.
> 
> 
> While i was observing one of these slowly times, I realized the time
> wait of processors come close to 100% and nfsd and kjournald process
> become to D status (uniterruptible sleep) .Does someone know why this
> can be happening or how can I troubleshoot it?
> 
> Below is a 'draw' of my top at one of these moments.
> 
> [root@cromo src]# top
> top - 10:59:02 up 6 days, 19:30, 17 users,  load average: 14.77, 13.46, 13.00
> Tasks: 189 total,   1 running, 188 sleeping,   0 stopped,   0 zombie
> Cpu0  :  0.0% us,  0.4% sy,  0.0% ni,  0.2% id, 98.5% wa,  0.0% hi,  0.9% si
> Cpu1  :  0.0% us,  0.4% sy,  0.0% ni,  0.0% id, 99.6% wa,  0.0% hi,  0.0% si
> Cpu2  :  0.0% us,  0.2% sy,  0.0% ni,  7.8% id, 92.0% wa,  0.0% hi,  0.0% si
> Cpu3  :  0.2% us,  0.8% sy,  0.0% ni,  0.0% id, 98.7% wa,  0.2% hi,  0.0% si
  All processors are in iowait - i.e. waiting for IO.

> Mem:   4025540k total,  4018264k used,     7276k free,     7908k buffers
> Swap:  4096564k total,     3288k used,  4093276k free,  3553252k cached
> 
>  3941 root      15   0     0    0    0 D    2  0.0  80:29.30 nfsd
>  3938 root      15   0     0    0    0 D    1  0.0  81:02.02 nfsd
>  2459 root      15   0     0    0    0 D    1  0.0  30:57.04 kjournald
>  3937 root      15   0     0    0    0 D    1  0.0  82:07.99 nfsd
>    96 root      15   0     0    0    0 S    0  0.0  34:12.48 kswapd0
>  3940 root      15   0     0    0    0 D    0  0.0  80:22.55 nfsd
>  3942 root      15   0     0    0    0 D    0  0.0  80:23.66 nfsd
>  3939 root      15   0     0    0    0 D    0  0.0  82:22.55 nfsd
  It seems like heavy disk/network activity. You can try running
vmstat 1
  It will print every second the situation of your memory / IO
subsystem. You should especially see the ---io--- column ('bi' means
blocks in, 'bo' blocks outputted). I guess they'd contain some
non-trivial values...
  BTW: I guess the processes wake up eventually, don't they?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
