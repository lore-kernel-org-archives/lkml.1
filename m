Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbZKKUvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbZKKUvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758821AbZKKUvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:51:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:60964 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbZKKUvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:51:41 -0500
Subject: Re: [BUG] cpu controller can't provide fair CPU time for each group
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4AFB2109.8010708@nortel.com>
References: <4AEF94E8.3030403@cn.fujitsu.com>
	 <1257846518.4648.18.camel@twins>
	 <20091111134910.5F42.E1E9C6FF@jp.fujitsu.com>
	 <1257924007.23203.18.camel@twins>  <4AFB2109.8010708@nortel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Nov 2009 21:51:31 +0100
Message-ID: <1257972691.4039.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 14:39 -0600, Chris Friesen wrote:
> On 11/11/2009 01:20 AM, Peter Zijlstra wrote:
> > On Wed, 2009-11-11 at 15:21 +0900, Yasunori Goto wrote:
> > 
> >> When users use cpuset/cpu affinity, then they would like to controll cpu affinity.
> >> Not CPU time.
> > 
> > What are people using affinity for? The only use of affinity is to
> > restrict or disable the load-balancer. Don't complain the load-balancer
> > doesn't work when you're taking active steps to hinder its work.
> 
> I have one active user of scheduler groups (using CKRM though, but they
> want to switch to a new kernel using CFS and sched groups in the near
> future).
> 
> They want to run their app on one cpu by itself with as little
> interference as possible.  Pure cpu processing, not even any I/O except
> via shared memory buffers.  Everything else gets done on the other cpu,
> but they want to control how much of the other cpu is assigned to packet
> processing, how much to system maintenance, normal user shell commands, etc.
> 
> This would seem like a case where some sort of cpuset/affinity  and
> sched groups would be expected to play nice together.

Agreed, and I'd like the load-balance partition feature of cpusets and
the cpu task-groups to work well together, except that the current
interface doesn't allow that nicely.



