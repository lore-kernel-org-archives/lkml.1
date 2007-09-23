Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbXIWPxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbXIWPxn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 11:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbXIWPxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 11:53:35 -0400
Received: from mail.gmx.net ([213.165.64.20]:41163 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751659AbXIWPxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 11:53:35 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18upIJoCzEuPAht0FidCf3aUxMBaI/2IRP8THGNYS
	+ma/c/CArvZi7i
Subject: Re: [git] CFS-devel, updates
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tong Li <tong.n.li@intel.com>, dimm <dmitry.adamushko@gmail.com>,
       linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20070923115847.GA13061@elte.hu>
References: <1190188261.9185.21.camel@Homer.simpson.net>
	 <1190191368.8687.5.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0709190944560.11561@tongli.jf.intel.com>
	 <1190264114.6411.4.camel@Homer.simpson.net>
	 <1190272507.27867.20.camel@Homer.simpson.net>
	 <20070920075155.GA31641@elte.hu>
	 <1190275870.9232.6.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0709212018480.16240@tongli.jf.intel.com>
	 <1190455308.7404.19.camel@Homer.simpson.net>
	 <1190531662.11524.15.camel@Homer.simpson.net>
	 <20070923115847.GA13061@elte.hu>
Content-Type: text/plain
Date: Sun, 23 Sep 2007 17:53:30 +0200
Message-Id: <1190562810.6531.10.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-23 at 13:58 +0200, Ingo Molnar wrote:

> i'm also wondering - do we even need sync_vruntime() at all? Now that we 
> fix up vruntime while we migrate tasks across rqs, the global notion of 
> vruntime makes less and less of a sense.

Yeah, I was wondering that too, but it does seem to be needed.  If I
make it a noop, and run the pinned tasks with an unpinned make -j2 test,
Xorg at nice -5 still takes hits...

se.wait_max              :            11.513462
se.wait_max              :             6.250911
se.wait_max              :            15.181511
se.wait_max              :           188.963625
se.wait_max              :             4.951569
se.wait_max              :            11.391749

...which begs the question "gee, what happens if I pin a nice 0 hog to
CPU0, and a nice 19 hog to CPU1 with the queues never ever syncing?".

The answer to that one seems to be "Don't even think about it!".  This
needs more investigation... there's gotta be a 32 bit thingie hiding in
there.  I lost control for a few seconds, got it back, then lost it
again forever (sysrq-b worked though, hmm).

	-Mike

