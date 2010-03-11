Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab0CKBVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 20:21:13 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55011 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab0CKBVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 20:21:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 11 Mar 2010 10:17:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Righi <arighi@develer.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 0/5] memcg: per cgroup dirty limit (v6)
Message-Id: <20100311101726.f58d24e9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100311093913.07c9ca8a.kamezawa.hiroyu@jp.fujitsu.com>
References: <1268175636-4673-1-git-send-email-arighi@develer.com>
	<20100311093913.07c9ca8a.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010 09:39:13 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > The performance overhead is not so huge in both solutions, but the impact on
> > performance is even more reduced using a complicated solution...
> > 
> > Maybe we can go ahead with the simplest implementation for now and start to
> > think to an alternative implementation of the page_cgroup locking and
> > charge/uncharge of pages.
> > 
> 
> maybe. But in this 2 years, one of our biggest concerns was the performance.
> So, we do something complex in memcg. But complex-locking is , yes, complex.
> Hmm..I don't want to bet we can fix locking scheme without something complex.
> 
But overall patch set seems good (to me.) And dirty_ratio and dirty_background_ratio
will give us much benefit (of performance) than we lose by small overheads.

IIUC, this series affects trgger for background-write-out.

Could you show some score which dirty_ratio give us benefit in the cases of

	- copying a file in a memcg which hits limit
	  ex) copying a 100M file in 120MB limit.  etc..

	- kernel make performance in limited memcg.
	  ex) making a kernel in 100MB limit (too large ?)
    etc....(when an application does many write and hits memcg's limit.)

But, please get enough ack for changes in generic codes of dirty_ratio.

Thank you for your work.

Regards,
-Kame

