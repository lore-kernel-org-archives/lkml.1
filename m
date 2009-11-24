Return-Path: <linux-kernel-owner+w=401wt.eu-S932744AbZKXKrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbZKXKrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 05:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932713AbZKXKrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 05:47:20 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55261 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710AbZKXKrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 05:47:19 -0500
Date: Tue, 24 Nov 2009 19:46:25 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Subject: Re: [PATCH 4/7] nandsim: Don't use PF_MEMALLOC
Cc: kosaki.motohiro@jp.fujitsu.com,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
In-Reply-To: <4B0AEA33.3010306@nokia.com>
References: <1258988417.18407.44.camel@localhost> <4B0AEA33.3010306@nokia.com>
Message-Id: <20091124194532.AFC2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Thank you for this useful comments.

> > I vaguely remember Adrian (CCed) did this on purpose. This is for the
> > case when nandsim emulates NAND flash on top of a file. So there are 2
> > file-systems involved: one sits on top of nandsim (e.g. UBIFS) and the
> > other owns the file which nandsim uses (e.g., ext3).
> > 
> > And I really cannot remember off the top of my head why he needed
> > PF_MEMALLOC, but I think Adrian wanted to prevent the direct reclaim
> > path to re-enter, say UBIFS, and cause deadlock. But I'd thing that all
> > the allocations in vfs_read()/vfs_write() should be GFP_NOFS, so that
> > should not be a probelm?
> > 
> 
> Yes it needs PF_MEMALLOC to prevent deadlock because there can be a
> file system on top of nandsim which, in this case, is on top of another
> file system.
> 
> I do not see how mempools will help here.
> 
> Please offer an alternative solution.

I have few questions.

Can you please explain more detail? Another stackable filesystam
(e.g. ecryptfs) don't have such problem. Why nandsim have its issue?
What lock cause deadlock?



