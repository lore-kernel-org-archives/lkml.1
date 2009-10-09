Return-Path: <linux-kernel-owner+w=401wt.eu-S932236AbZJIGPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbZJIGPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 02:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZJIGPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 02:15:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55022
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294AbZJIGPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 02:15:32 -0400
Date: Thu, 08 Oct 2009 23:15:27 -0700 (PDT)
Message-Id: <20091008.231527.251721755.davem@davemloft.net>
To: npiggin@suse.de
Cc: torvalds@linux-foundation.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       kiran@scalex86.org, peterz@infradead.org
Subject: Re: [rfc][patch] store-free path walking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091009035050.GC4287@wotan.suse.de>
References: <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain>
	<20091008123622.GA30316@wotan.suse.de>
	<20091009035050.GC4287@wotan.suse.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>
Date: Fri, 9 Oct 2009 05:50:50 +0200

> OK, I got rid of this guy from the RCU walk. Basically now hold
> vfsmount_lock over the entire RCU path walk (which also pins the mnt)
> and use a seqlock in the fs struct to get a consistent mnt,dentry
> pair. This also simplifies the walk because we don't need the
> complexity to avoid mntget/mntput (just do one final mntget on the
> resulting mnt before dropping vfsmount_lock).
> 
> vfsmount_lock adds one per-cpu atomic for the spinlock, and we
> remove two thread-shared atomics for fs->lock so a net win for
> both single threaded performance and thread-shared scalability.
> Latency is no problem because we hold rcu_read_lock for the same
> length of time anyway.
> 
> The parallel git diff workload is improved by serveral percent.

Sounds sweet Nick, can't wait to play with your next set of
patches here.
