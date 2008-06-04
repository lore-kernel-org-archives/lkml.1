Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbYFDRlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbYFDRlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbYFDRli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:41:38 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37154 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754866AbYFDRlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:41:37 -0400
Date: Wed, 4 Jun 2008 12:41:26 -0500
From: Paul Jackson <pj@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: maxk@qualcomm.com, ioe-lkml@rameria.de, sivanich@sgi.com,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       kernel@kolivas.org, dfults@sgi.com, devik@cdi.cz, dino@in.ibm.com,
       emmanuel.pacaud@univ-poitiers.fr, deweerdt@free.fr, mingo@elte.hu,
       colpatch@us.ibm.com, nickpiggin@yahoo.com.au, rostedt@goodmis.org,
       oleg@tv-sign.ru, paulmck@us.ibm.com, menage@google.com,
       rddunlap@osdl.org, suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
Message-Id: <20080604124126.0d281a99.pj@sgi.com>
In-Reply-To: <877id5v1fg.fsf@basil.nowhere.org>
References: <20080601213019.14ea8ef8.pj@sgi.com>
	<1212446707.6269.26.camel@lappy.programming.kicks-ass.net>
	<48447C75.8040203@qualcomm.com>
	<200806030156.00155.ioe-lkml@rameria.de>
	<4844BB41.7000605@qualcomm.com>
	<4845D825.6000403@qualcomm.com>
	<20080603194148.56dfebe1.pj@sgi.com>
	<48461ADA.8020303@qualcomm.com>
	<877id5v1fg.fsf@basil.nowhere.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi wrote:
> Right now the system boot could put pages from some daemon in there before any 
> cpusets are set up and there's no easy way to get them away again

We (SGI) routinely handle that need with a custom init program,
invoked with the init= parameter to the booting kernel, which
sets up cpusets and then invokes the normal (real) init program
in a cpuset configured to exclude those CPUs and nodes which we
want to remain unloaded.  For example, on a 256 CPU, 64 node
system, we might have init running on a single node of 4 CPUs,
and leave the remaining 63 nodes and 252 CPUs isolated from all
the usual user level daemons started by init.

There is no need for additional kernel changes to accomplish this.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
