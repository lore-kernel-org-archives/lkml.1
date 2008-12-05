Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbYLEHws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbYLEHws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 02:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbYLEHwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 02:52:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48229
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750720AbYLEHwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 02:52:38 -0500
Date: Thu, 04 Dec 2008 23:52:38 -0800 (PST)
Message-Id: <20081204.235238.229578299.davem@davemloft.net>
To: arjan@infradead.org
Cc: mingo@elte.hu, paulus@samba.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, eranian@googlemail.com, dada1@cosmosbay.com,
       robert.richter@amd.com, hpa@zytor.com, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081204230206.6e083d51@infradead.org>
References: <18744.29747.728320.652642@cargo.ozlabs.ibm.com>
	<20081205063131.GB12785@elte.hu>
	<20081204230206.6e083d51@infradead.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@infradead.org>
Date: Thu, 4 Dec 2008 23:02:06 -0800

> On Fri, 5 Dec 2008 07:31:31 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Btw., i'm curious, why would we want to do that? It skews the results
> > if the task continues executing and counters stop. To get the highest 
> > quality profiling output the counters should follow the true state of
> > the task that is profiled - and events should be passed to the
> > monitoring task asynchronously. The _events_ can contain precise
> > coupled information 
> > - but the counters should continue.
> 
> btw stopping the task on counter overflow is an issue for things that
> want to self profile, like JITs

They can fork off a thread to do this.

No blocking on couter overflow leads to inaccurate results.
This is a pretty fundamental aspect of perf counter usage.
