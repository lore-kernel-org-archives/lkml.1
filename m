Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbYKDVRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbYKDVRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 16:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbYKDVQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 16:16:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754135AbYKDVQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 16:16:49 -0500
Date: Tue, 4 Nov 2008 13:16:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: rientjes@google.com, cl@linux-foundation.org, npiggin@suse.de,
       menage@google.com, dfults@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] cpuset writeback throttling
Message-Id: <20081104131637.68fbe055.akpm@linux-foundation.org>
In-Reply-To: <1225831988.7803.1939.camel@twins>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
	<20081104124753.fb1dde5a.akpm@linux-foundation.org>
	<1225831988.7803.1939.camel@twins>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2008 21:53:08 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2008-11-04 at 12:47 -0800, Andrew Morton wrote:
> > On Thu, 30 Oct 2008 12:23:10 -0700 (PDT)
> > David Rientjes <rientjes@google.com> wrote:
> > 
> > > This is the revised cpuset writeback throttling patchset
> > 
> > I'm all confused about why this is a cpuset thing rather than a cgroups
> > thing.  What are the relationships here?
> > 
> > I mean, writeback throttling _should_ operate upon a control group
> > (more specifically: a memcg), yes?  I guess you're assuming a 1:1
> > relationship here?
> 
> I think the main reason is that we have per-node vmstats so the cpuset
> extention is relatively easy. Whereas we do not currently maintain
> vmstats on a cgroup level - although I imagine that could be remedied.

It didn't look easy to me - it added a lot more code in places which are
already wicked complex.

I'm trying to understand where this is all coming from and what fits
into where.  Fiddling with a cpuset's mems_allowed for purposes of
memory partitioning is all nasty 2007 technology, isn't it?  Does a raw
cpuset-based control such as this have a future?


