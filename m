Return-Path: <linux-kernel-owner+w=401wt.eu-S1757719AbYCCRlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719AbYCCRlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758462AbYCCRg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:36:28 -0500
Received: from relay2.sgi.com ([192.48.171.30]:45760 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759151AbYCCRg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:36:27 -0500
Date: Mon, 3 Mar 2008 11:36:21 -0600
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: maxk@qualcomm.com, mingo@elte.hu, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-Id: <20080303113621.1dfdda87.pj@sgi.com>
In-Reply-To: <1204545445.11412.6.camel@twins>
References: <20080227222103.673194000@chello.nl>
	<1204311351.6243.130.camel@lappy>
	<20080229190223.GA17820@elte.hu>
	<47C87084.3090208@qualcomm.com>
	<1204318980.6243.133.camel@lappy>
	<47C8771C.1070001@qualcomm.com>
	<1204545445.11412.6.camel@twins>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter wrote:
> The system group can overlap with anything that does need system services.

I suppose IRQs need to overlap like this, but cpusets often can't
overlap like this.

If a system has the cgroup hierarchy you draw:

  /cgroup
  /cgroup/system
  /cgroup/system/boot

  /cgroup/big_honking_app
  /cgroup/rt_domain

this must not force the cpuset hierarchy to be:

  /dev/cpuset
  /dev/cpuset/system
  /dev/cpuset/system/boot

  /dev/cpuset/big_honking_app
  /dev/cpuset/rt_domain

I guess this means IRQs cannot be added to the cpuset subsystem
of cgroups.  Rather they have to be added to some other cgroup
subsystem, perhaps a new one just for IRQs.

In perhaps the most common sort of cpuset hierarchy:

  /dev/cpuset
  /dev/cpuset/boot
  /dev/cpuset/batch_sched
  /dev/cpuset/big_honking_app
  /dev/cpuset/rt_domain

none of boot or its siblings overlap.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
