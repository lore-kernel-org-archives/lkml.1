Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbYACRhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbYACRhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757911AbYACRgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:36:51 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:45105 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844AbYACRgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:36:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=b6pB3HBvnLmeJzqqFoppypviuG0xjTDOdFPDg9Zlbmq9zWuWD4w/lhuRHIUWeWN5W7/6zEaovRUjzQIEA9VSBA9FOSGqT6BV/ht7TrYRRbeOtZI8z/7q7OvWGMqx15mbNMzaQIKsYcyTOAm0CssG6gCYabMbz7J06WwwYbSGvyE=
Subject: Re: [PATCH] kprobes: Introduce is_kprobe_fault()
From: Harvey Harrison <harvey.harrison@gmail.com>
To: ananth@in.ibm.com
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080103070526.GA7690@in.ibm.com>
References: <1199333115.6323.104.camel@brick>
	 <20080103070526.GA7690@in.ibm.com>
Content-Type: text/plain
Date: Thu, 03 Jan 2008 09:36:46 -0800
Message-Id: <1199381806.6323.109.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-03 at 12:35 +0530, Ananth N Mavinakayanahalli wrote:
> On Wed, Jan 02, 2008 at 08:05:14PM -0800, Harvey Harrison wrote:
> 
> Thanks for the cleanup...
> 
> ...
> 
> > diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
> > index a2273d4..f2e909b 100644
> > --- a/arch/x86/mm/fault_32.c
> > +++ b/arch/x86/mm/fault_32.c
> > @@ -33,28 +33,6 @@
> > 
> >  extern void die(const char *,struct pt_regs *,long);
> > 
> > -#ifdef CONFIG_KPROBES
> > -static inline int notify_page_fault(struct pt_regs *regs)
> > -{
> > -	int ret = 0;
> > -
> > -	/* kprobe_running() needs smp_processor_id() */
> > -	if (!user_mode_vm(regs)) {
> 		^^^^^^^^^^^
> For x86_32, this check is important. See commit
> 6444541671bd821b950dbaafee70d65188198aa6 (Never allow int3 traps
> from V8086 mode to enter the kprobes handler) for precise reason why its
> user_mode_vm() and not user_mode() for x86_32.
> 
> You'll need to make room for this check in the generic macro below...

Or just keep X86_32 using its existing notify_page_fault, everyone else
can use the new is_kprobe_fault.  I'll wait for a bit and see if
the s390 or avr32 people respond before resending.

Harvey



