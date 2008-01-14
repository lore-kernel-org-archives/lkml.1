Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbYANDzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbYANDzK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 22:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbYANDy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 22:54:58 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34783 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754290AbYANDy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 22:54:57 -0500
Message-ID: <400282904.32255@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Mon, 14 Jan 2008 11:54:39 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Joerg Platte <jplatte@naasa.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
References: <200801071151.11200.lists@naasa.net> <200801130905.44855.jplatte@naasa.net> <400212488.11031@ustc.edu.cn> <200801131049.33111.jplatte@naasa.net> <20080113115933.GA11045@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080113115933.GA11045@mail.ustc.edu.cn>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JEGPH-0001uw-Df@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 07:59:33PM +0800, Fengguang Wu wrote:
> On Sun, Jan 13, 2008 at 10:49:31AM +0100, Joerg Platte wrote:
> > register_jprobe(ext2_writepage) = 0
> > register_jprobe(requeue_io) = 0
> > register_kprobe(submit_bio) = 0
> > requeue_io:
> > inode 114019(sda7/.kde) count 2,2 size 0 pages 1
> > 0	2	0	U____
> > requeue_io:
> > inode 114025(sda7/cache-ibm) count 2,1 size 0 pages 1
> > 0	2	0	U____
> > requeue_io:
> > inode 114029(sda7/socket-ibm) count 2,3 size 0 pages 1
> > 0	2	0	U____
> > requeue_io:
> > inode 114017(sda7/0266584877) count 3,6 size 0 pages 1
> > 0	2	0	U____
> 
> It helps. Thank you, Joerg!
> 
> The .kde/cache-ibm/socket-ibm/0266584877 above are directories.
> It's weird that dirs would have their own mappings in ext2. In

Oh, ext2 dirs have their own mapping pages. Not the same with ext3.

> particular this bug is triggered because the dir mapping page has
> PAGECACHE_TAG_DIRTY set and PG_dirty cleared, staying in an
> inconsistent state.

Just found that a deleted dir will enter that inconsistent state when
someone still have reference to it...

