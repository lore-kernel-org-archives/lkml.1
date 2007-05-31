Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbXEaVWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbXEaVWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 17:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbXEaVVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 17:21:53 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148AbXEaVVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 17:21:52 -0400
Date: Thu, 31 May 2007 14:21:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 8/9] F00F bug fixup for i386 - use conditional calls
Message-Id: <20070531142138.60dbc8a9.akpm@linux-foundation.org>
In-Reply-To: <20070531210755.GA904@Krystal>
References: <20070530140025.917261793@polymtl.ca>
	<20070530140229.491376274@polymtl.ca>
	<20070530133359.5a553e0c.akpm@linux-foundation.org>
	<20070531210755.GA904@Krystal>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 17:07:55 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Andrew Morton (akpm@linux-foundation.org) wrote:
>  
> > > Use the faster conditional calls for F00F bug handling in do_page_fault.
> > > 
> > 
> > I guess this means that CONDCALL will be enabled on pretty much all i386,
> > in which case making the whole feature Kconfigurable is starting to look
> > marginal.
> > 
> > Perhaps a better approach would have to made this change dependent upon
> > CONDCALL, rather than forcing it on.
> > 
> 
> Do you mean making X86_F00F_BUG depend on COND_CALL instead of selecting
> it ?

yup

> > > +	if (cond_call(fix_f00f, do_f00f_workaround(regs, address)))
> > > +		return;
> > 
> > We do a cond_call() to an inlined function?  That's a bit weird, isn't it?
> > 
> 
> Yes, but it works :) I will add this information to the documentation.

But why does it work?  Did the compiler generate an out-of-line copy
of the function?  If so, we'll end up with multiple copies of the function if
there are other callers.  If not, the `inline' was pointless.
