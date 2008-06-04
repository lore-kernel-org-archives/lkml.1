Return-Path: <linux-kernel-owner+w=401wt.eu-S1760225AbYFDMTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbYFDMTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYFDMSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:18:54 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:41611 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbYFDMSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:18:53 -0400
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul Jackson <pj@sgi.com>, ioe-lkml@rameria.de, sivanich@sgi.com,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       kernel@kolivas.org, dfults@sgi.com, devik@cdi.cz, dino@in.ibm.com,
       emmanuel.pacaud@univ-poitiers.fr, deweerdt@free.fr, mingo@elte.hu,
       colpatch@us.ibm.com, nickpiggin@yahoo.com.au, rostedt@goodmis.org,
       oleg@tv-sign.ru, paulmck@us.ibm.com, menage@google.com,
       rddunlap@osdl.org, suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may have realtime uses)
From: Andi Kleen <andi@firstfloor.org>
References: <20080601213019.14ea8ef8.pj@sgi.com>
	<1212446707.6269.26.camel@lappy.programming.kicks-ass.net>
	<48447C75.8040203@qualcomm.com>
	<200806030156.00155.ioe-lkml@rameria.de>
	<4844BB41.7000605@qualcomm.com> <4845D825.6000403@qualcomm.com>
	<20080603194148.56dfebe1.pj@sgi.com> <48461ADA.8020303@qualcomm.com>
Date: Wed, 04 Jun 2008 14:18:11 +0200
In-Reply-To: <48461ADA.8020303@qualcomm.com> (Max Krasnyansky's message of "Tue, 03 Jun 2008 21:32:26 -0700")
Message-ID: <877id5v1fg.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Jun 2008 12:11:06.0415 (UTC) FILETIME=[10E9BBF0:01C8C63C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Krasnyansky <maxk@qualcomm.com> writes:

> We've seen exactly two replies with usage examples. Dimitri's case is legit
> but can be handled much better (as in it not only avoids timers, but any other
> kernel work) with cpu hotplug and cpusets. Ingo's case is bogus because it
> does not actually do what he needs. There is a much better way to do exactly
> what he needs which involves only cpu hotplug and has nothing to do with the
> scheduler and such.

One example I've seen in the past is that someone wanted to isolate a node
completely from any memory traffic to avoid performance disturbance
for memory intensive workloads.

Right now the system boot could put pages from some daemon in there before any 
cpusets are set up and there's no easy way to get them away again
(short of migratepages for all running pids, but that's pretty ugly and won't 
cover kernel level allocations and also can mess up locality)

Given the use case wants more a "isolnodes", but given that there
tends to be enough free memory at boot "isolcpus" tended to work.

-Andi

