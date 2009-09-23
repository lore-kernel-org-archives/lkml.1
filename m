Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbZIWAzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbZIWAzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 20:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbZIWAzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 20:55:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753284AbZIWAzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 20:55:51 -0400
Date: Tue, 22 Sep 2009 17:54:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-Id: <20090922175452.d66400dd.akpm@linux-foundation.org>
In-Reply-To: <20090923002220.GA6382@localhost>
References: <20090922054913.GA27260@sli10-desk.sh.intel.com>
	<1253601612.8439.274.camel@twins>
	<20090922080505.GB9192@localhost>
	<1253606965.8439.281.camel@twins>
	<20090922082427.GA24888@localhost>
	<1253608335.8439.283.camel@twins>
	<20090922155259.GL10825@think>
	<20090923002220.GA6382@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 08:22:20 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:

> Jens' per-bdi writeback has another improvement. In 2.6.31, when
> superblocks A and B both have 100000 dirty pages, it will first
> exhaust A's 100000 dirty pages before going on to sync B's.

That would only be true if someone broke 2.6.31.  Did they?

SYSCALL_DEFINE0(sync)
{
	wakeup_pdflush(0);
	sync_filesystems(0);
	sync_filesystems(1);
	if (unlikely(laptop_mode))
		laptop_sync_completion();
	return 0;
}

the sync_filesystems(0) is supposed to non-blockingly start IO against
all devices.  It used to do that correctly.  But people mucked with it
so perhaps it no longer does.

