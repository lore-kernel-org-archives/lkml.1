Return-Path: <linux-kernel-owner+w=401wt.eu-S1758362AbYGDCHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362AbYGDCHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 22:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbYGDCHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 22:07:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334AbYGDCHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 22:07:43 -0400
Date: Thu, 3 Jul 2008 19:03:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linuxfoundation.org,
       peterz@infradead.org, stable@kernel.org
Subject: Re: [PATCH] hrtimer: prevent migration for raising softirq
Message-Id: <20080703190306.d2c7edd5.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.58.0807032148340.7798@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0807031428440.7798@gandalf.stny.rr.com>
	<20080703155302.5f86d8f4.akpm@linux-foundation.org>
	<Pine.LNX.4.58.0807032148340.7798@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2008 21:56:00 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> 
> On Thu, 3 Jul 2008, Andrew Morton wrote:
> 
> >
> > On Thu, 3 Jul 2008 14:31:26 -0400 (EDT)
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > > Due to a possible deadlock, the waking of the softirq was pushed outside
> > > of the hrtimer base locks. See commit 0c96c5979a522c3323c30a078a70120e29b5bdbc
> >
> > Please quote at least the patch title rather than raw hashes.
> 
> Sorry, will do next time. I'm getting to use to git.
> 
> >
> > afaict that patch isn't in 2.6.25 yet you copied stable@kernel.org.
> > Please clarify.
> 
> The reason I did so is because that commit has a Cc: stable@kernel.org.
> I figured that if that patch is in queue for stable this one should be in
> right afterwards.
> 
> >
> > >
> > > Unfortunately this allows the task to migrate after setting up the softirq
> > > and raising it. Since softirqs run a queue that is per-cpu we may raise the
> > > softirq on the wrong CPU and this will keep the queued softirq task from
> > > running.
> > >
> > > To solve this issue, this patch disables preemption around the releasing
> > > of the hrtimer lock and raising of the softirq.
> > >
> >
> > This seems to be 2.6.26 material and is inapplicable to 2.6.25?
> >
> 
> [/me goes to look at the 2.6.25.4 he has sitting around]
> 
> The above mentioned commit (Title: hrtimer: raise softirq unlocked to
> avoid circular lock dependency) is, in fact, in 2.6.25.4.
> 

Ah, OK, I'm a dope.
