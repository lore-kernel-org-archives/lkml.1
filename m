Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbYJaOhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbYJaOhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 10:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbYJaOhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 10:37:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34838 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbYJaOhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 10:37:00 -0400
Date: Fri, 31 Oct 2008 10:36:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Abhishek Sagar <sagar.abhishek@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ftrace: distinguish kretprobe'd functions in trace
 logs
In-Reply-To: <alpine.DEB.1.10.0810302227360.21031@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0810311036130.20157@gandalf.stny.rr.com>
References: <483C53EE.2060602@gmail.com> <alpine.DEB.1.10.0810302227360.21031@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 30 Oct 2008, Steven Rostedt wrote:
> 
> > +
> > +#ifdef CONFIG_KRETPROBES
> > +static inline int kretprobed(unsigned long addr)
> > +{
> > +	return addr == (unsigned long)kretprobe_trampoline;
> 
> Hi Abhishek,
> 
> Now that this code is in mainline, it has become apparent that 
> kretprobe_trampoline is not defined on all archs as a global like it is in 
> x86. This needs to be fixed (it breaks ia64 build).
> 

Also note that kretprobe_trampoline will not be the return address.

Hmm, I think I can solve this by not even doing the test here, but simply 
on the name itself.

-- Steve

