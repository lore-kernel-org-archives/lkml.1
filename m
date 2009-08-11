Return-Path: <linux-kernel-owner+w=401wt.eu-S1751513AbZHKLxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbZHKLxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbZHKLxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:53:30 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:52330 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415AbZHKLx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:53:28 -0400
Subject: Re: kmemleak: Protect the seq start/next/stop sequence by
	rcu_read_lock()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090811073205.GA17476@elte.hu>
References: <20090729152101.1878.71159.stgit@pc1117.cambridge.arm.com>
	 <20090802111453.GA24927@elte.hu>
	 <1249919718.10848.55.camel@pc1117.cambridge.arm.com>
	 <20090810184527.GA9601@elte.hu>
	 <1249945003.26205.23.camel@pc1117.cambridge.arm.com>
	 <20090811073205.GA17476@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 11 Aug 2009 09:55:05 +0100
Message-Id: <1249980905.27150.11.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Aug 2009 08:55:06.0411 (UTC) FILETIME=[6C4547B0:01CA1A61]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-11 at 09:32 +0200, Ingo Molnar wrote:
> * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > I tried similar config and with the mainline kernel I get some 
> > lockups (several seconds) with CONFIG_PREEMPT disabled on ARM 
> > machines or x86 during a scanning episode but it eventually 
> > completes the scanning. With the kmemleak patches for the next 
> > merging window, I don't get any lockups as it has more 
> > cond_resched() calls.
> 
> How big are those patches? Kmemleak is new in .31 so if it fixes a 
> real problem it might still be acceptable.

My patches for -next were posted here -
http://lkml.org/lkml/2009/7/24/166 - but the relevant ones are pretty
small (review/ack is welcomed):

http://lkml.org/lkml/2009/7/24/176 - allow rescheduling during object
scanning
http://lkml.org/lkml/2009/7/24/173 - inform kmemleak about kernel stack
allocation (needs ack by the x86 people)
http://lkml.org/lkml/2009/7/24/172 - always scan the task stacks

-- 
Catalin

