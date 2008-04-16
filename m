Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbYDPTHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbYDPTHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYDPTH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:07:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48007 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbYDPTH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:07:27 -0400
Date: Wed, 16 Apr 2008 15:07:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, nouveau@lists.freedesktop.org
Subject: Re: [BUG/PATCH] x86 mmiotrace: dynamically disable non-boot CPUs
In-Reply-To: <20080416183258.GA30490@elte.hu>
Message-ID: <Pine.LNX.4.58.0804161506300.30154@gandalf.stny.rr.com>
References: <20080413224207.4430a09c@daedalus.pq.iki.fi>
 <20080413230552.33ca587a@daedalus.pq.iki.fi> <20080414065713.GB16163@elte.hu>
 <20080414210242.2329997d@daedalus.pq.iki.fi> <20080416114609.GA20054@elte.hu>
 <20080416205902.6186d349@daedalus.pq.iki.fi> <20080416183258.GA30490@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Apr 2008, Ingo Molnar wrote:
>
> so lets fix those preemptability bugs. They show that the
> cpu-up/cpu-down ops are called from atomic context - it should normally
> be straightforward to sort out - there's no particular reason why the
> ->open()/->close() methods of an ftrace plugin should run in atomic
> context. Steve, any ideas where the atomicity might come from?
>

They shouldn't be called in an atomic section. The only thing I do to
protect them is call mutex_lock/unlock. Those should allow preemption to
take place.

-- Steve

