Return-Path: <linux-kernel-owner+w=401wt.eu-S932384AbYCEBMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384AbYCEBMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760803AbYCEBMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:12:07 -0500
Received: from relay2.sgi.com ([192.48.171.30]:40420 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760419AbYCEBMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:12:05 -0500
Date: Tue, 4 Mar 2008 19:11:59 -0600
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-Id: <20080304191159.a02be58b.pj@sgi.com>
In-Reply-To: <47CDA885.3000103@qualcomm.com>
References: <20080227222103.673194000@chello.nl>
	<1204311351.6243.130.camel@lappy>
	<20080229190223.GA17820@elte.hu>
	<47C87084.3090208@qualcomm.com>
	<1204318980.6243.133.camel@lappy>
	<47C8771C.1070001@qualcomm.com>
	<1204545445.11412.6.camel@twins>
	<20080303113621.1dfdda87.pj@sgi.com>
	<1204567052.6241.4.camel@lappy>
	<20080303121033.c8c9651c.pj@sgi.com>
	<1204568316.8514.18.camel@twins>
	<20080304013534.4e51ae48.pj@sgi.com>
	<1204628762.6241.46.camel@lappy>
	<47CDA885.3000103@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max K wrote:
> Yeah, that would definitely be awkward.

Yeah - agreed - awkward.

Forget that idea (allowing the same irq in multiple 'irqs' files.)

It seems to me that we get into trouble trying to cram that 'system'
cpuset into the cpuset hierarchy, where that system cpuset is there to
hold a list of irqs, but is only partially a good fit for the existing
cpuset hierarchy.

Could this irq configuration be partly a system-wide configuration
decision (which irqs are 'system' irqs), and partly a per-cpuset
decision -- which cpusets (such as a real-time one) want to disable
the usual system irqs that everyone else gets.

The cpuset portion of this should take only a single per-cpuset Boolean
flag -- which if set True (1), asks the system to "please leave my CPUs
off the list of CPUs receiving the usual system irqs."

Then the list of "usual system irqs" would be established in some /proc
or /sys configuration.  Such irqs would be able to go to any CPUs
except those CPUs which found themselves in a cpuset with the above
per-cpuset Boolean flag set True (1).

How does all this interact with /proc/irq/N/smp_affinity?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
