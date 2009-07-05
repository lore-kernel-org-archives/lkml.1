Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbZGEXzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbZGEXzQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 19:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbZGEXzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 19:55:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45875 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbZGEXzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 19:55:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 6 Jul 2009 08:53:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Blum <bblum@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, lizf@cn.fujitzu.com
Subject: Re: [PATCH 1/2] Adds a read-only "procs" file similar to "tasks"
 that  shows only unique tgids
Message-Id: <20090706085323.cc4b6133.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830907040910k5c9d720bqafdf596bbc005783@mail.gmail.com>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	<20090702232620.3969.16680.stgit@menage.mtv.corp.google.com>
	<20090702164649.303c4952.akpm@linux-foundation.org>
	<2f86c2480907021731h13e0bb95q94f06829eded9aa6@mail.gmail.com>
	<20090702175341.fd2e26d5.akpm@linux-foundation.org>
	<6599ad830907021808o6f3bb51eh324e4bf13544d83e@mail.gmail.com>
	<20090702183004.1e3f4315.akpm@linux-foundation.org>
	<20090703145441.f526793f.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830907030852p2cd667e3m353d68448e0cdc6a@mail.gmail.com>
	<3f9558558c68d9e2fe00f7c7681c3764.squirrel@webmail-b.css.fujitsu.com>
	<6599ad830907040910k5c9d720bqafdf596bbc005783@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Jul 2009 09:10:58 -0700
Paul Menage <menage@google.com> wrote:

> 2009/7/3 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> > Anyway, above algorithm shows that it's enough to have per-cgroup bitmap
> > (size can be dinamically changed) rather than big table and ugly sort().
> > How about adding per-cgroup taskid bitmap ?
> > clear/set is very easy.
> >
> 
> A per-cgroup bitmap of task ids would mean (assuming that it's
> implemented as a sparse tree like an IDA) that you'd add extra
> allocations and possible failure points in the fork path - right now
> the fork overhead imposed by the cgroups framework itself is just
> linking yourself into your parent's css_set and bumping its refcount.
> I guess there probably are workloads where doing more work at
> fork/exit time and less at "tasks" scan time is a win, but that has to
> be balanced against those where fork/exit performance is more
> critical, and the fact that it would be adding another way that fork
> could fail.
> 
ok.

But "sorting" at procs file seems not sane ;)

-Kame

> Paul
> 

