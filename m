Return-Path: <linux-kernel-owner+w=401wt.eu-S1760304AbZD1Sh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760304AbZD1Sh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZD1ShM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:37:12 -0400
Received: from waste.org ([66.93.16.53]:48883 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbZD1ShK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:37:10 -0400
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
From: Matt Mackall <mpm@selenic.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <12c511ca0904281111r10f37a5coe5a2750f4dbfbcda@mail.gmail.com>
References: <20090428010907.912554629@intel.com>
	 <20090428014920.769723618@intel.com> <20090428065507.GA2024@elte.hu>
	 <20090428083320.GB17038@localhost>
	 <12c511ca0904281111r10f37a5coe5a2750f4dbfbcda@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 13:34:31 -0500
Message-Id: <1240943671.938.575.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 11:11 -0700, Tony Luck wrote:
> On Tue, Apr 28, 2009 at 1:33 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 1) FAST
> >
> > It takes merely 0.2s to scan 4GB pages:
> >
> >        ./page-types  0.02s user 0.20s system 99% cpu 0.216 total
> 
> OK on a tiny system ... but sounds painful on a big
> server. 0.2s for 4G scales up to 3 minutes 25 seconds
> on a 4TB system (4TB systems were being sold two
> years ago ... so by now the high end will have moved
> up to 8TB or perhaps 16TB).
> 
> Would the resulting output be anything but noise on
> a big system (a *lot* of pages can change state in
> 3 minutes)?

Bah. The rate of change is proportional to #cpus, not #pages. Assuming
you've got 1024 processors, you could run the scan in parallel in .2
seconds still.

It won't be an atomic snapshot, obviously. But stopping the whole
machine on a system that size is probably not what you want anyway.

-- 
http://selenic.com : development and support for Mercurial and Linux


