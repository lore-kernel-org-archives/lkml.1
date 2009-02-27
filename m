Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbZB0E7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbZB0E7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 23:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbZB0E67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 23:58:59 -0500
Received: from bilbo.ozlabs.org ([203.10.76.25]:57738 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbZB0E66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 23:58:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18855.27479.443830.724534@cargo.ozlabs.ibm.com>
Date: Fri, 27 Feb 2009 15:25:59 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bharata B Rao <bharata.rao@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuacct: add a branch prediction
In-Reply-To: <20090226122623.GC23099@elte.hu>
References: <20090226172234.a931931f.kamezawa.hiroyu@jp.fujitsu.com>
	<49A65455.4030204@cn.fujitsu.com>
	<20090226174033.094e4834.kamezawa.hiroyu@jp.fujitsu.com>
	<344eb09a0902260210y44c0684by9b22f041116d3f7c@mail.gmail.com>
	<18f6db017e5d44596e828e0753f28e75.squirrel@webmail-b.css.fujitsu.com>
	<1235645076.4645.4781.camel@laptop>
	<934198669efa83e838a52284e2c4f8b5.squirrel@webmail-b.css.fujitsu.com>
	<1235647682.4948.15.camel@laptop>
	<145d0010d65060bb089d5a87e06cbd0d.squirrel@webmail-b.css.fujitsu.com>
	<1235650806.4948.71.camel@laptop>
	<20090226122623.GC23099@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Thu, 2009-02-26 at 21:06 +0900, KAMEZAWA Hiroyuki wrote:
> > > Hmm.. some routine like
> > > atomic64_read() can help this ? (But I don't want to use atomic_t here..)
> > 
> > Yeah, atomic64_t has been proposed numerous times, and x86 
> > could actually implement that using cmpxchg8b, just not sure 
> > about all the other 32bit archs, and if we start using it in 
> > the scheduler, they'd better have it implemented.
> 
> I have written a working atomic64_t implementation for 
> tip:perfcounters/core, for 32-bit x86.

atomic64_t would be a big problem for 32-bit powerpc.  We'd have to
use an array of spinlocks, or make atomic64_t actually be 12 bytes so
we have a lock word to use.

Paul.
