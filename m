Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbZJSNUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbZJSNUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 09:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbZJSNUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 09:20:35 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:62511 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755908AbZJSNUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 09:20:35 -0400
Subject: Re: Leaks in trace reported by kmemleak
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1255953605.31096.26.camel@pc1117.cambridge.arm.com>
References: <c4e36d110910150159j6092d0d1lb20434bd9d43d8ce@mail.gmail.com>
	 <4AD6EF65.6080602@cn.fujitsu.com>
	 <1255605778.10164.49.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910160045y52d80450g1d803dd2090a2bd8@mail.gmail.com>
	 <1255690674.3008.24.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910160632y4448475dp1ae66dfc01ff8448@mail.gmail.com>
	 <tnxbpk7a0ok.fsf@pc1117.cambridge.arm.com>
	 <c4e36d110910160728n5ceefaa8u6b9989aec0564628@mail.gmail.com>
	 <c4e36d110910160807i2298dacp7d37289ca3ad25f@mail.gmail.com>
	 <1255711285.3008.59.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910190215j129e61ey5e20634a4bc19292@mail.gmail.com>
	 <1255953605.31096.26.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 19 Oct 2009 14:20:22 +0100
Message-Id: <1255958422.31096.33.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2009 13:20:23.0811 (UTC) FILETIME=[EA488530:01CA50BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-19 at 13:00 +0100, Catalin Marinas wrote:
> On Mon, 2009-10-19 at 11:15 +0200, Zdenek Kabelac wrote:
> > What is however interesting is the false positive leak for
> > dma_debug_init(). Which is sometimes listed and sometimes not - the
> > memory is allocated just once in the code during boot, so it's strange
> > that pointers to that area are sometimes out of kmemleak scan.
> 
> A workaround I had in the past was to not report an object unless it was
> found as a leak in two consecutive scans. I should probably reinstate
> this feature (could be optimised to use a second prio_tree containing
> only objects found as leaks).

OK, I re-added a form of this to the kmemleak.git tree and simplified
the scanning logic (meant initially to reduce the false positives). Now,
for an object to be reported, it needs to be found as leak during two
consecutive scans (this works around pointer moving from a structure to
a different one which was already scanned).

If you have time, could you please give it a try and see whether you
still get transient false positives?

As for the patch showing where an object is referred from, I think it's
still useful for debugging possible false negatives, so I'll leave it
in.

Thanks.

-- 
Catalin

