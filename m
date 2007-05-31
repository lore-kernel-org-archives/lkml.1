Return-Path: <linux-kernel-owner+w=401wt.eu-S1758907AbXEaVih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907AbXEaVih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 17:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbXEaVia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 17:38:30 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:64761 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666AbXEaVi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 17:38:29 -0400
Date: Thu, 31 May 2007 17:38:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 8/9] F00F bug fixup for i386 - use conditional calls
Message-ID: <20070531213827.GD904@Krystal>
References: <20070530140025.917261793@polymtl.ca> <20070530140229.491376274@polymtl.ca> <20070530133359.5a553e0c.akpm@linux-foundation.org> <20070531210755.GA904@Krystal> <20070531142138.60dbc8a9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070531142138.60dbc8a9.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:37:47 up 3 days,  6:16,  4 users,  load average: 0.04, 0.22, 0.24
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Thu, 31 May 2007 17:07:55 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Andrew Morton (akpm@linux-foundation.org) wrote:
> >  
> > > > Use the faster conditional calls for F00F bug handling in do_page_fault.
> > > > 
> > > 
> > > I guess this means that CONDCALL will be enabled on pretty much all i386,
> > > in which case making the whole feature Kconfigurable is starting to look
> > > marginal.
> > > 
> > > Perhaps a better approach would have to made this change dependent upon
> > > CONDCALL, rather than forcing it on.
> > > 
> > 
> > Do you mean making X86_F00F_BUG depend on COND_CALL instead of selecting
> > it ?
> 
> yup
> 
> > > > +	if (cond_call(fix_f00f, do_f00f_workaround(regs, address)))
> > > > +		return;
> > > 
> > > We do a cond_call() to an inlined function?  That's a bit weird, isn't it?
> > > 
> > 
> > Yes, but it works :) I will add this information to the documentation.
> 
> But why does it work?  Did the compiler generate an out-of-line copy
> of the function?  If so, we'll end up with multiple copies of the function if
> there are other callers.  If not, the `inline' was pointless.

Yes, it's doing an out-of-line copy. Just like the compiler would have
done if we place a call to an inline function within a if() { } block.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
