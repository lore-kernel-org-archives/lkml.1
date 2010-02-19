Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0BSRmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:42:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:1359 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab0BSRmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:42:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J/TCB7K3gLE8+LnGTaxxMzaAHSqI5VSIYd6cF7NOllOdBvlhq4VtalK7VqpOtiW8J+
         Ts3bavIAGFOrNlA0zKkBCkU70HC0tMsZyM+JvKPWvg7zBJmROaHOCPv8+QeIQS8ulm9E
         5+VCOkA+o/941fCYkavJNIzNOY0lweNWR0njc=
Date: Fri, 19 Feb 2010 18:41:53 +0100
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
Message-ID: <20100219174150.GD4921@nowhere>
References: <4B7881AC.5070209@redhat.com> <1266516001-7753-3-git-send-regression-fweisbec@gmail.com> <20100219085831.GA10837@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100219085831.GA10837@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 02:28:31PM +0530, K.Prasad wrote:
> On Thu, Feb 18, 2010 at 07:00:01PM +0100, Frederic Weisbecker wrote:
> 
> > diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> > index 017d937..0c1033d 100644
> > --- a/arch/x86/kernel/ptrace.c
> > +++ b/arch/x86/kernel/ptrace.c
> > @@ -702,7 +702,7 @@ static unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
> >  	} else if (n == 6) {
> >  		val = thread->debugreg6;
> >  	 } else if (n == 7) {
> > -		val = ptrace_get_dr7(thread->ptrace_bps);
> > +		val = thread->ptrace_dr7;
> 
> Some more comments that I missed out in the previous mail...
> 
> Shouldn't ptrace_get_dr7() function be entirely removed now, given that
> its only caller no longer invokes it?
> 
> >  	}
> >  	return val;
> >  }
> > @@ -778,8 +778,11 @@ int ptrace_set_debugreg(struct task_struct *tsk, int n, unsigned long val)
> >  			return rc;
> >  	}
> >  	/* All that's left is DR7 */
> > -	if (n == 7)
> > +	if (n == 7) {
> >  		rc = ptrace_write_dr7(tsk, val);
> 
> And ptrace_write_dr7() should be made to populate thread->ptrace_dr7 if
> it is going to return a success.
> 
> > +		if (!rc)
> > +			thread->ptrace_dr7 = val;
> > +	}
> > 
> >  ret_path:
> >  	return rc;
> > -- 
> > 1.6.2.3
> > 
> 
> Thanks,
> K.Prasad
> 


This is urgent so I'm pushing the two patches right away as they fix the
regression and are not intrusive.

Let's further improve that later, for a merge window, ok?

Thanks.

