Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbZCJQyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbZCJQyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757981AbZCJQuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:50:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758041AbZCJQux convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:50:53 -0400
Date: Tue, 10 Mar 2009 09:48:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: gyang <graf.yang@analog.com>, Bryan Wu <cooloney@kernel.org>,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/18] Blackfin Serial Driver: use barrier instead of 
 cpu_relax for Blackfin SMP like patch
Message-Id: <20090310094810.2ffe1f63.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0903100325k6cbcf73ek8e5f3723b2c4bb0a@mail.gmail.com>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
	<1236321780-28718-3-git-send-email-cooloney@kernel.org>
	<20090306143756.738db0ee.akpm@linux-foundation.org>
	<1236679631.5183.72.camel@dy>
	<8bd0f97a0903100325k6cbcf73ek8e5f3723b2c4bb0a@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009 06:25:08 -0400 Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Tue, Mar 10, 2009 at 06:07, gyang wrote:
> > On Fri, 2009-03-06 at 14:37 -0800, Andrew Morton wrote:
> >> On Fri,  6 Mar 2009 14:42:44 +0800
> >> Bryan Wu <cooloney@kernel.org> wrote:
> >>
> >> > From: Graf Yang <graf.yang@analog.com>
> >> >
> >> > We are making a SMP like patch to blackfin, cpu_relax() is replaced by a
> >> > data cache flush function which will count it to a per-cpu counter.
> >> > If this serial function is called too early, the per-cpu data area have
> >> > not been initialized, this call will cause crash.
> >>
> >> That's a bug in blackfin architecture support.  The kernel should be
> >> able to call cpu_relax() at any time, surely.  It's a very low-level
> >> and simple thing.
> >>
> >> > So we'd like to use barrier() instead of cpu_relax().
> >> >
> >>
> >> barrier() is purely a compiler concept.  We might as well just remove
> >> the cpu_relax() altogether.
> >
> > Do you mean remove cpu_relax(), and either not add barrier() here?
> 
> afaik, early printk all runs before SMP is setup, so having it be a
> 100% busy wait is fine

No, blackfin is busted, please fix this bug in blackfin core.

What happens if core kernel code decides to run cpu_relax() prior to
initialising per-cpu data?
