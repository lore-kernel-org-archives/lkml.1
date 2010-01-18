Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056Ab0ARTVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab0ARTVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 14:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031Ab0ARTVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 14:21:40 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:58105 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab0ARTVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 14:21:39 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Jim Keniston <jkenisto@us.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B548521.7000704@redhat.com>
References: <20100116184833.2s0zihwbggkgccsk@imap.linux.ibm.com>
	 <4B548521.7000704@redhat.com>
Content-Type: text/plain
Date: Mon, 18 Jan 2010 11:21:22 -0800
Message-Id: <1263842482.5059.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 10:58 -0500, Masami Hiramatsu wrote:
> Jim Keniston wrote:
> > Not really.  For #3 (boosting), you need to know everything for #2,  
> > plus be able to compute the length of each instruction -- which we can  
> > now do for x86.  To emulate an instruction (#4), you need to replicate  
> > what it does, side-effects and all.  The x86 instruction set seems to  
> > be adding new floating-point instructions all the time, and I bet even  
> > Masami doesn't know what they all do, but so far, they all seem to  
> > adhere to the instruction-length rules encoded in Masami's instruction  
> > decoder.
> 
> Actually, current x86 decoder doesn't support FP(x87) instructions.(even
> it already supported AVX) But I think it's not so hard to add it.
> 

At one point I verified that it worked for all the x87 instructions in
libm:
https://www.redhat.com/archives/utrace-devel/2009-March/msg00031.html
I'm pretty sure I tested mmx instructions as well.  But I guess this was
before you rearranged the opcode tables.

Yeah, it wouldn't be hard to add back in, at least for purposes of
computing instruction lengths.

Jim

