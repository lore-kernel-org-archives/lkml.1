Return-Path: <linux-kernel-owner+w=401wt.eu-S1760646AbZCYLlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646AbZCYLlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760634AbZCYLlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:41:39 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:34139 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760622AbZCYLlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:41:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ckCuVjQG21KGlcdnYNl5h23zq++rPydBNmQeHfGpFMaVPEgRw9N4qd7LNjoB/QSmVN
         j92HCFkFJFfstq2VPIFSelIDMwZvGDr9d+9GryCxtiHglFfOczOijR/kNdsBlNiqbiv1
         GzL46zy+8EBxLDjS/LUrrzn+pZ9sNF0EzXJmg=
Date: Wed, 25 Mar 2009 12:41:31 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Abhishek Sagar <sagar.abhishek@gmail.com>, Tim Bird <tim.bird@am.sony.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Anyone working on ftrace function graph support on ARM?
Message-ID: <20090325114129.GA5976@nowhere>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <49C95EAF.7030901@gmail.com> <20090324224857.GE5975@nowhere> <20090325084248.GF4697@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325084248.GF4697@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 08:42:48AM +0000, Russell King - ARM Linux wrote:
> On Tue, Mar 24, 2009 at 11:48:58PM +0100, Frederic Weisbecker wrote:
> > On Tue, Mar 24, 2009 at 06:29:03PM -0400, Abhishek Sagar wrote:
> > > Instead of just restoring the old backed-up args, lr can be fixed up
> > > inside the entry hook to point to the return hook. So when the traced
> > > function returns, it actually returns to the return hook (where we can
> > > restore the original return address). This means that
> > > -finstrument-functions is not required at all. This is analogous to how
> > > kretprobes work. The only difference here is that instead of planting a
> > > kprobe at the function entry and redirecting the function return to the
> > > profiling exit routine, we can use mcount. This is slightly more
> > > complicated to implement but can be a very efficient alternative to
> > > kretprobes.
> > > --
> > > Abhishek
> > > 
> > 
> > Indeed, you need to override lr, that even the only solution.
> > I was still thinking in an x86 way with its on stack return address.
> 
> As pointed out in my previous mail, identifying where on the stack the
> return address is stored is only possible for OABI with frame pointers.
> 
> EABI will probably be possible with the stack unwinding code, but it
> probably won't be cheap.  The EABI unwinder is scheduled for merging
> during the present now-open merge window.


Hm, if I'm not wrong, the function tracer already depends on frame pointer,
this is necessary to retrieve the parent of the caller.

