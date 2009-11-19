Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbZKSUKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbZKSUKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 15:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbZKSUKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 15:10:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49390 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbZKSUKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 15:10:22 -0500
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Daney <ddaney@caviumnetworks.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
In-Reply-To: <4B05A16D.1050807@zytor.com>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>
	 <20091119072040.GA23579@elte.hu>
	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain>
	 <1258653562.22249.682.camel@gandalf.stny.rr.com>
	 <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com>
	 <4B058CCD.8050605@redhat.com>
	 <alpine.LFD.2.00.0911191039470.2793@localhost.localdomain>
	 <alpine.LFD.2.00.0911191041471.2793@localhost.localdomain>
	 <alpine.LFD.2.00.0911191047350.2793@localhost.localdomain>
	 <4B05982B.6060200@caviumnetworks.com>
	 <1258658886.22249.874.camel@gandalf.stny.rr.com>
	 <4B05A16D.1050807@zytor.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 19 Nov 2009 15:10:27 -0500
Message-Id: <1258661427.22249.975.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-19 at 11:50 -0800, H. Peter Anvin wrote:

> > Perhaps we could create another profiler? Instead of calling mcount,
> > call a new function: __fentry__ or something. Have it activated with
> > another switch. This could make the performance of the function tracer
> > even better without all these exceptions.
> > 
> > 	<function>:
> > 		call __fentry__
> > 		[...]
> > 
> 
> Calling the profiler immediately at the entry point is clearly the more
> sane option.  It means the ABI is well-defined, stable, and independent
> of what the actual function contents are.  It means that ABI isn't the
> normal C ABI (the __fentry__ function would have to preserve all
> registers), but that's fine...

mcount already has that requirement (saving all/most regs). Anyway, you
are right, we don't care. The tracer should carry the blunt of the load,
not the individual callers.

-- Steve


