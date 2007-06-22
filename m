Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbXFVP3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbXFVP3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 11:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757235AbXFVP30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 11:29:26 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33370 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756735AbXFVP3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 11:29:25 -0400
Date: Fri, 22 Jun 2007 08:29:15 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Wright <chrisw@sous-sol.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt] CONFIG_PARAVIRT and CONFIG_MCOUNT don't play well
	together
Message-ID: <20070622152915.GQ3723@sequoia.sous-sol.org>
References: <20070622080634.GP3723@sequoia.sous-sol.org> <20070622083330.GB19382@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622083330.GB19382@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> * Chris Wright <chrisw@sous-sol.org> wrote:
> > Current -rt is broken when compiling with CONFIG_PARAVIRT and 
> > CONFIG_MCOUNT both enabled.  Because CONFIG_MCOUNT disables 
> > CONFIG_REGPARM, the calling convention must once again be explicit 
> > with fastcall.  However, this was only half-way addressed in the -rt 
> > patch (adding fastcall back to paravirt_ops function ptr declaration 
> > but not the actual function definitions) so the compiled kernel has 
> > caller putting stuff in registers and callee pulling things from the 
> > stack. Impressive how far into boot it can get despite that ;-) Thanks 
> > to Steven Rostedt for prodding me and starting the initial debugging.
> 
> thanks! I ran into this before and asked for the fastcalls to not be 
> removed from upstream paravirt.c but to no avail it seems. It does no 
> harm to anyone to keep the 'fastcall' declarations and definitions for 
> places where _actual assembly code_ depends on the calling convention. 
> Could someone please send this upstream-wards too?

Yes, I agree, it's actually documenting the subtlety of the calling
convention, not just noise in the source.  The upstream patch is
different, I'll sort one out.

thanks,
-chris
