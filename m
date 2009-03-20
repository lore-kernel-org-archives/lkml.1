Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbZCTAcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbZCTAcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 20:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbZCTAcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 20:32:31 -0400
Received: from www.tglx.de ([62.245.132.106]:44411 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137AbZCTAca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 20:32:30 -0400
Date: Fri, 20 Mar 2009 01:31:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>
Subject: [Announce] 2.6.29-rc78rt1
In-Reply-To: <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain> <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain> <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain>
 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain> <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.
   
   - port forward to 2.6.29-rc8
   - disable -rt conflicting config options
   - hotplug cpu fixes (peterz)
   - slab/pagealloc lock breaks (peterz / tglx) 
   - sigqueue caching for -rt tasks
   - posixtimer thread avoid useless wakeups
   - various build fixes (mingo, frank ....)
   - lots of tracer updates from -tip (check the tip git logs)

The outstanding improvement is the slab/pagealloc change which breaks
and splits locking and brought down worst case latencies in
problematic use cases from >500us to <100us.

As a side note:

   There seems to be a wide spread underestimation of the problem spots
   exposed by preempt-rt. The usual shrug off answer is:

	"I don't care about -rt. Come back if you can expose the same
	problem in the mainline kernel."

   This is a fundamentally wrong answer.

   	preempt-rt mostly exposes existing latency spots and magnifies
   	them
   
	Reducing latencies in -rt by a factor 5 will be not that
	prominent in a non-rt setup, but the problematic code area
	will still produce measureable latency problems.
   
   I'm well aware of the tradeoff between determinitic behaviour and
   throughput, but problematic spots (e.g. lock contentions) hurt
   both.

   So can we please put down the stupid "I don't care about -rt"
   attitudes and accept that we have to think about the mutual
   benefits of deterministic and throughput aspects without hurting
   each other ?


Download locations:
 
    http://rt.et.redhat.com/download/
    http://www.kernel.org/pub/linux/kernel/projects/rt/
  
Information on the RT patch can be found at:

    http://rt.wiki.kernel.org/index.php/Main_Page

to build the 2.6.29-rc8-rt1 tree, the following patches should be
applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29-rc8.tar.bz2
  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29-rc8-rt1.bz2
  
The broken out patches are also available at the same download
locations.

Enjoy !

       tglx
 
P.S.: ARM/PowerPC support is in the pipeline and will be available
      with -rt2 (hopefully :)

