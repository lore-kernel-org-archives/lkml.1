Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbZL3Jql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbZL3Jql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 04:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbZL3Jqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 04:46:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54670 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZL3Jqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 04:46:39 -0500
Subject: Re: [PATCH v3 1/5] perf_event: introduce 'inject' event and get HZ
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B3B1F3C.8010509@cn.fujitsu.com>
References: <4B27702F.1080507@cn.fujitsu.com>
	 <20091215142325.GC5833@nowhere> <4B30C2D1.4030006@cn.fujitsu.com>
	 <4B30C3A0.909@cn.fujitsu.com> <20091228075417.GB20039@elte.hu>
	 <4B3991C1.6060303@cn.fujitsu.com> <1262164786.7135.166.camel@laptop>
	 <4B3B1F3C.8010509@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 10:45:57 +0100
Message-ID: <1262166357.7135.177.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-30 at 17:37 +0800, Xiao Guangrong wrote:
> > I really dislike the name, event injection to me would be like a write()
> > interface where you provide the actual event data to be stuffed in the
> > output stream.
> > 
> 
> Yes, it like write and it writes something form kernel to perf.
> And, i think this name is suitable for it's doing that injects an
> 'artificial' event, it's well if you have other name for it :-)

No, what I means is that you cannot actually inject an arbitrary event.
Sure it injects something, but that's pretty limited.

> > This just seems like a very weird way of getting data out. A kind of
> > like sysconf() but done very strange.
> > 
> 
> It's since some parameter is only used by perf, suce as HZ in this patch and
> 'relocation offset' in my other patchset, it also well if has better way to
> do it :-)

The thing is, this proposed interface is very much tied to perf and
makes it basically impossible for !perf to use. Whereas I can imagine
esp. the relocation offset to be interesting for other things. Basically
everything needing to resolve a kernel symbol.



