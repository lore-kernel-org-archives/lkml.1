Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab0BWRJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 12:09:40 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:46429 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab0BWRJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 12:09:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P/+WRMZkZkZTcpwZ1fiwVfbqV9C52kVJ8pTR0otrRnFroAOsyNbZRnFh2adRJEtnk/
         tSWh36dOg3pwUvZqLPrmsNO5AWiN0zg2n9qdt/1gHy3tSfeBJS4JXqUxDDTi6c81sz9j
         G/mJcVmnVo6gCUE9YmwWeeZWsEnONI9tQgRFE=
Date: Tue, 23 Feb 2010 22:40:58 +0530
From: Rabin Vincent <rabin@rab.in>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Catalin Marinas <catalin.marinas@arm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 09/10] ARM: ftrace: add Thumb-2 support to dynamic
 ftrace
Message-ID: <20100223171058.GA5836@debian>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
 <1266090518-31120-10-git-send-email-rabin@rab.in>
 <1266932100.19540.12.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266932100.19540.12.camel@frodo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 08:35:00AM -0500, Steven Rostedt wrote:
> On Sun, 2010-02-14 at 01:18 +0530, Rabin Vincent wrote:
> > --- a/arch/arm/include/asm/ftrace.h
> > +++ b/arch/arm/include/asm/ftrace.h
> > @@ -18,7 +18,11 @@ struct dyn_arch_ftrace {
> >  
> >  static inline unsigned long ftrace_call_adjust(unsigned long addr)
> >  {
> > +#ifdef CONFIG_THUMB2_KERNEL
> > +	return addr & ~1;
> 
> Would it be safe to do that for all arm archs? Instead of adding a
> config option around it. Or do some arm archs need the lsb set.
> 
> I'm just saying a comment here would look better than #ifdef #else.

You're right; I'll change this.  It's safe even when we build for the
ARM instruction set.

Rabin
