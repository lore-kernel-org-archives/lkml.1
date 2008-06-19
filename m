Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbYFSVSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbYFSVSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbYFSVSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:18:43 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:58148 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbYFSVSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:18:42 -0400
Date: Thu, 19 Jun 2008 23:17:48 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [BUG] CFS vs cpu hotplug
Message-ID: <20080619211748.GB6180@osiris.ibm.com>
References: <20080619161949.GA11062@osiris.ibm.com> <1213898711.3223.107.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213898711.3223.107.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 08:05:10PM +0200, Peter Zijlstra wrote:
> On Thu, 2008-06-19 at 18:19 +0200, Heiko Carstens wrote:
> > Hi Ingo, Peter,
> > 
> > I'm still seeing kernel crashes on cpu hotplug with Linus' current git tree.
> > All I have to do is to make all cpus busy (make -j4 of the kernel source is
> > sufficient) and then start cpu hotplug stress.
> > It usually takes below a minute to crash the system like this:
> > 
> > Unable to handle kernel pointer dereference at virtual kernel address 005a800000031000
> > Oops: 0038 [#1] PREEMPT SMP
> > Modules linked in:
> > CPU: 1 Not tainted 2.6.26-rc6-00232-g9bedbcb #356
> > Process swapper (pid: 0, task: 000000002fe7ccf8, ksp: 000000002fe93d78)
> > Krnl PSW : 0400e00180000000 0000000000032c6c (pick_next_task_fair+0x34/0xb0)
> 
> I presume this is:
> 
>                 se = pick_next_entity(cfs_rq);

Yes, that is correct. Sorry, missed to tell about this detail.
