Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450AbZL3KGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbZL3KGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 05:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZL3KGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 05:06:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:34785 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbZL3KGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 05:06:43 -0500
Subject: Re: [PATCH v3 1/5] perf_event: introduce 'inject' event and get HZ
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1262165789.7135.170.camel@laptop>
References: <4B27702F.1080507@cn.fujitsu.com>
	 <20091215142325.GC5833@nowhere> <4B30C2D1.4030006@cn.fujitsu.com>
	 <4B30C3A0.909@cn.fujitsu.com> <20091228075417.GB20039@elte.hu>
	 <4B3991C1.6060303@cn.fujitsu.com> <1262164786.7135.166.camel@laptop>
	 <20091230092830.GA18190@elte.hu>  <1262165789.7135.170.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 11:06:06 +0100
Message-ID: <1262167566.7135.189.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-30 at 10:36 +0100, Peter Zijlstra wrote:
> On Wed, 2009-12-30 at 10:28 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Tue, 2009-12-29 at 13:21 +0800, Xiao Guangrong wrote:
> > > > 'inject' event is a very useful feature and it's suggested by Ingo
> > > > [ See http://lkml.org/lkml/2009/12/28/31 ]
> > > 
> > > I really dislike the name, event injection to me would be like a write() 
> > > interface where you provide the actual event data to be stuffed in the 
> > > output stream.
> > > 
> > > This just seems like a very weird way of getting data out. A kind of like 
> > > sysconf() but done very strange.
> > 
> > What kind of API would you suggest?
> 
> sysconf() seems ideal for getting single, mostly constant variables out
> of the kernel, we already have non POSIX (read Linux specific) names in
> there.
> 
> _SC_KERNEL_RELOCATION_OFFSET
> _SC_KERNEL_HZ
> 
> or somethings like that comes to mind.

OK so there is no sysconf() syscall and its all implemented in glibc,
which is utter suckage.. will have to come up with something saner then.

