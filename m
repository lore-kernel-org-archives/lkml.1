Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0BSSDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 13:03:43 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:54239 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab0BSSDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 13:03:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=QyUapU+c9zsSljyih5wmiX+PQsUtsQ2UObAoX6tmAffOTUXAU8cFYOEtsIcF4WAOCn
         77TIDnvo8ziLa6ifmkgk3wMl1bAMa1RcKq/eGMw/jkycqGHEPJ8WUUDkjr6eBhDb1rgC
         WT3rIV5GtDOPj/HGlnmhKT6fwPTqRQHGr/wZY=
Date: Fri, 19 Feb 2010 19:03:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Michael Stefaniuc <mstefani@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J . Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 2/2] hw-breakpoint: Keep track of dr7 local enable bits
Message-ID: <20100219180332.GE4921@nowhere>
References: <4B7881AC.5070209@redhat.com> <1266516001-7753-3-git-send-regression-fweisbec@gmail.com> <20100219084523.GA3525@in.ibm.com> <c62985531002190734j5da1e4bfw54ed4283f4d724e0@mail.gmail.com> <20100219175859.GA4736@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100219175859.GA4736@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 11:28:59PM +0530, K.Prasad wrote:
> On Fri, Feb 19, 2010 at 04:34:03PM +0100, Frederic Weisbecker wrote:
> > 2010/2/19 K.Prasad <prasad@linux.vnet.ibm.com>:
> > > So, the thread's copy of DR7 (in thread->ptrace_dr7) stores the
> > > requested data even if the 'write' onto DR7 i.e. ptrace_write_dr7()
> > > failed. This can be the other way round i.e. populate the thread's copy
> > > of DR7 only if the write was successful.
> > 
> > 
> > 
> > No. We store the new dr7 value only if ptrace_set_dr7() didn't fail.
> > 
> > 
> > 
> > > I think it will be in consonance with the v2.6.32 behaviour as well. For
> > > instance, in the code snippet from ptrace_set_debugreg() in v2.6.32
> > > below:
> > >                for (i = 0; i < 4; i++)
> > >                        if ((DR7_MASK >> ((data >> (16 + 4*i)) & 0xf)) & 1)
> > >                                return -EIO;
> > >                child->thread.debugreg7 = data;
> > >
> > > The thread's copy of DR7 is populated only if the incoming data is
> > > found to be valid.
> > 
> > 
> > This is also what does this patch. thread->ptrace_dr7 is only
> > changed if ptrace_set_dr7() succeeded.
> > 
> > Thanks.
> 
> hmmh...I see...looks like I experienced single-bit ECC as I read
> the patch :-) Yes, let debugreg7 store values only when a valid bkpt
> request comes in.



Great :) I was feeling uncomfortable to push that out without
your ack. May I add it?

Thanks.

