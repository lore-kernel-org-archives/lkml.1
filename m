Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbZKSQIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbZKSQIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757295AbZKSQIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:08:32 -0500
Received: from www.tglx.de ([62.245.132.106]:41629 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757077AbZKSQIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:08:31 -0500
Date: Thu, 19 Nov 2009 17:06:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Haley <aph@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
In-Reply-To: <4B0567E0.5080803@redhat.com>
Message-ID: <alpine.LFD.2.00.0911191704110.24119@localhost.localdomain>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain> <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org> <20091119072040.GA23579@elte.hu> <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain> 
 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain> <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain> <4B0567E0.5080803@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009, Andrew Haley wrote:
> Thomas Gleixner wrote:
> > There is no real obvious reason why the edi magic needs to be done
> > _before_ 
> > 
> > 	push   %ebp
> > 	mov    %esp,%ebp
> 
> Sure there is: unless you do the adjustment first %ebp won't be 16-aligned.

And why is this not done in 99% of the functions in the kernel, just
in this one and some random others ?
 
> We're aligning the stack properly, as per the ABI requirements.  Can't
> you just fix the tracer?

Where is that ABI requirement that

 	push   %ebp

needs to happen on an aligned stack ? 

And why is this something GCC did not care about until GCC4.4 ?

Thanks,

	tglx


