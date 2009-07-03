Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZGCH4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZGCH4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZGCH4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:56:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59183 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbZGCH4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:56:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 3 Jul 2009 16:54:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <menage@google.com>, Benjamin Blum <bblum@google.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       lizf@cn.fujitzu.com
Subject: Re: [PATCH 1/2] Adds a read-only "procs" file similar to "tasks"
 that  shows only unique tgids
Message-Id: <20090703165423.0483f535.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090702235527.7ddc873c.akpm@linux-foundation.org>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	<20090702232620.3969.16680.stgit@menage.mtv.corp.google.com>
	<20090702164649.303c4952.akpm@linux-foundation.org>
	<2f86c2480907021731h13e0bb95q94f06829eded9aa6@mail.gmail.com>
	<20090702175341.fd2e26d5.akpm@linux-foundation.org>
	<6599ad830907021808o6f3bb51eh324e4bf13544d83e@mail.gmail.com>
	<2f86c2480907021817o79fce75yd9785aab682f7bb4@mail.gmail.com>
	<20090702190845.0cafc46a.akpm@linux-foundation.org>
	<6599ad830907022116n7a711c7fs52ff9b400ec8797f@mail.gmail.com>
	<20090702235527.7ddc873c.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jul 2009 23:55:27 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 2 Jul 2009 21:16:15 -0700 Paul Menage <menage@google.com> wrote:
> 
> > On Thu, Jul 2, 2009 at 7:08 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
> > >
> > > Why are we doing all this anyway? __To avoid presenting duplicated pids
> > > to userspace? __Nothing else?
> > 
> > To present the pids or tgids in sorted order. Removing duplicates is
> > only for the case of the "procs" file; that could certainly be left to
> > userspace, but it wouldn't by itself remove the existing requirement
> > for a contiguous array.
> > 
> > The seq_file iterator for these files relies on them being sorted so
> > that it can pick up where it left off even in the event of the pid set
> > changing between reads - it does a binary search to find the first pid
> > greater than the last one that was returned, so as to guarantee that
> > we return every pid that was in the cgroup before the scan started and
> > remained in the cgroup until after the scan finished; there are no
> > guarantees about pids that enter/leave the cgroup during the scan.
> 
> OIC.  Gee we made it hard for ourselves.  That tears it.
> 
At using "file" interface, it's not necessary to guarantee atomic-and-correct
result about list of pids. It's impossible.

readdir(/proc) does best-effort-jobs based on pids. plz do in such a way.
It uses find_ge_pid() to scanning all exisiting pids.


> > >
> > > btw, did pidlist_uniq() actually needs to allocate new memory for the
> > > output array? __Could it have done the filtering in-place?
> > 
> > Yes - or just omit duplicates in the seq_file iterator, I guess
> 
> OK.
> 
> 
> So now what?  lib/dynarray.c?

We never need array for user interface, IIUC.

Thanks,
-Kame

