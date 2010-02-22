Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0BVOgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 09:36:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60238 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab0BVOgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 09:36:11 -0500
X-Authority-Analysis: v=1.0 c=1 a=InyUbggdI00A:10 a=7U3hwN5JcxgA:10 a=pGLkceISAAAA:8 a=GrMDFnwiM8No-DILQKgA:9 a=d4JhUndn4rIs6YBaJ63fsKmql94A:4 a=MSl-tDqOz04A:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 05/06] kernel.h tracing stuff cleanup
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Neil Horman <nhorman@tuxdriver.com>, Vivek Goyal <vgoyal@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <ak@linux.intel.com>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Markus Metzger <markus.t.metzger@intel.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20100222142008.GA9032@darkstar>
References: <20100222142008.GA9032@darkstar>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 22 Feb 2010 09:36:06 -0500
Message-ID: <1266849367.24271.4386.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-22 at 22:20 +0800, Dave Young wrote:
> trace stuff in kernel.h should stay in their own head file 
> 
> cleanup trace declarations in kernel.h, put them into ring_buffer.h
> include ring_buffer.h in every file which need it

NAK, sorry.

1) it does not belong in ring_buffer.h. The ring buffer.h is for the
ring buffer only, and is agnostic to other tracing code.

2) trace_prink() and friends needs to be with printk. It is not used
much in the delivered kernel but it is used often in development. That
is, we purposely made it so it is not needed to add a header file to
everyplace you use trace_prink(). When debugging a problem,
trace_printk() needs to be as convenient as adding printk(), and by
needing to find "what header includes trace_printk()" will become an
overwhelming inconvenience.

-- Steve


> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>


