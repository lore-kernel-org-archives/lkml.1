Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab0BSR7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:59:13 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:48554 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab0BSR7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:59:09 -0500
Date: Fri, 19 Feb 2010 23:28:59 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Michael Stefaniuc <mstefani@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J . Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 2/2] hw-breakpoint: Keep track of dr7 local enable bits
Message-ID: <20100219175859.GA4736@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <4B7881AC.5070209@redhat.com> <1266516001-7753-3-git-send-regression-fweisbec@gmail.com> <20100219084523.GA3525@in.ibm.com> <c62985531002190734j5da1e4bfw54ed4283f4d724e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985531002190734j5da1e4bfw54ed4283f4d724e0@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 04:34:03PM +0100, Frederic Weisbecker wrote:
> 2010/2/19 K.Prasad <prasad@linux.vnet.ibm.com>:
> > So, the thread's copy of DR7 (in thread->ptrace_dr7) stores the
> > requested data even if the 'write' onto DR7 i.e. ptrace_write_dr7()
> > failed. This can be the other way round i.e. populate the thread's copy
> > of DR7 only if the write was successful.
> 
> 
> 
> No. We store the new dr7 value only if ptrace_set_dr7() didn't fail.
> 
> 
> 
> > I think it will be in consonance with the v2.6.32 behaviour as well. For
> > instance, in the code snippet from ptrace_set_debugreg() in v2.6.32
> > below:
> >                for (i = 0; i < 4; i++)
> >                        if ((DR7_MASK >> ((data >> (16 + 4*i)) & 0xf)) & 1)
> >                                return -EIO;
> >                child->thread.debugreg7 = data;
> >
> > The thread's copy of DR7 is populated only if the incoming data is
> > found to be valid.
> 
> 
> This is also what does this patch. thread->ptrace_dr7 is only
> changed if ptrace_set_dr7() succeeded.
> 
> Thanks.

hmmh...I see...looks like I experienced single-bit ECC as I read
the patch :-) Yes, let debugreg7 store values only when a valid bkpt
request comes in.

Thanks,
K.Prasad

