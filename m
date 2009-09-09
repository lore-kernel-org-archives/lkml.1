Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbZIIJlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbZIIJlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbZIIJlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:41:08 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44297 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbZIIJlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:41:07 -0400
Date: Wed, 9 Sep 2009 11:41:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
Subject: Re: [RFC] IO scheduler based IO controller V9
Message-ID: <20090909094109.GS18599@kernel.dk>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <4AA4B905.8010801@cn.fujitsu.com> <20090908191941.GF15974@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908191941.GF15974@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08 2009, Vivek Goyal wrote:
> On Mon, Sep 07, 2009 at 03:40:53PM +0800, Gui Jianfeng wrote:
> > Hi Vivek,
> > 
> > I happened to encount a bug when i test IO Controller V9.
> > When there are three tasks to run concurrently in three group,
> > that is, one is parent group, and other two tasks are running 
> > in two different child groups respectively to read or write 
> > files in some disk, say disk "hdb", The task may hang up, and 
> > other tasks which access into "hdb" will also hang up.
> > 
> > The bug only happens when using AS io scheduler.
> > The following scirpt can reproduce this bug in my box.
> > 
> 
> Hi Gui,
> 
> I tried reproducing this on my system and can't reproduce it. All the
> three processes get killed and system does not hang.

The key factor is likely the old IDE driver, since this is IO scheduler
related. It probably works if Gui uses libata instead, and you can
probably reproduce if you could use drivers/ide/ on a disk.

So the likely culprit is probably a missing queue restart somewhere on
IO completion.

-- 
Jens Axboe

