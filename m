Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbYCLUhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbYCLUhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 16:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbYCLUhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 16:37:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47310 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754426AbYCLUhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 16:37:19 -0400
Date: Wed, 12 Mar 2008 15:37:12 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: menage@google.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: boot cgroup questions
Message-Id: <20080312153712.bc5df7a1.pj@sgi.com>
In-Reply-To: <47D83858.4030806@qualcomm.com>
References: <47D73086.2030008@qualcomm.com>
	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>
	<47D7411E.1000009@qualcomm.com>
	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>
	<47D74595.4080100@qualcomm.com>
	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>
	<20080311235939.1ebee8e3.pj@sgi.com>
	<47D81FE1.6030205@qualcomm.com>
	<20080312135746.89456f2a.pj@sgi.com>
	<47D82AD2.1070108@qualcomm.com>
	<20080312143253.3dd72c7f.pj@sgi.com>
	<47D83858.4030806@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is what I meant by "deeper hierarchies" in the earlier emails.

These deeper hierarchies create an incompatibility in some common uses
of cpusets.

When my example had cpusets A, B and C, that was as stated, not as
might be modified to X, X/A, X/B and C.

If the user has or would have setup cpusets A, B and C because that's
what they needed to manage the CPU and Memory Node placement of their
tasks, then that's what they might have setup, and there is a good
chance that they would find the imposition of the extra 'X' cpuset to
be a problem, to require more code and to be a cause of bugs.

Adding irqs to the cpuset hierarchy isn't free; it can further overload
the hierarchy, with "deeper hierarchies" as you state.

If instead of deeper hierarchies, we allow the same irq to be listed in
more than one cpuset (unlike tasks, which only get one cpuset) then we
need some way, independent of the cpuset hierarchy, to determine how to
resolve conflicts.  We can't just add all the cpus together, allowing an
irq to be directed to any CPU which is listed in any cpuset that
accepts that irq, because a major use for this is to remove irqs from
certain realtime CPUs.

So ... if the natural hierarchy needed to map irqs to CPUs is not a
subset of the natural hierarchy needed to map tasks to sets of CPUs and
Nodes, then we either deepen the hierarchy (cross product of the the
two maps, essentially) or we allow the same irq to be listed in
multiple cpusets and provide some alternative mechanism, outside the
hierarchy, to resolve the resulting conflicts in the irq to CPU map.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
