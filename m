Return-Path: <linux-kernel-owner+w=401wt.eu-S1758653AbZBLCiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbZBLCiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 21:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758274AbZBLChW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 21:37:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49523 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758217AbZBLChQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 21:37:16 -0500
Date: Wed, 11 Feb 2009 21:37:14 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Michael Ellerman <michael@ellerman.id.au>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7][RFC] function graph tracer port to PowerPC
In-Reply-To: <1234405406.8142.4.camel@localhost>
Message-ID: <alpine.DEB.1.10.0902112131410.13954@gandalf.stny.rr.com>
References: <20090212011051.265346435@goodmis.org> <1234405406.8142.4.camel@localhost>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 12 Feb 2009, Michael Ellerman wrote:
> > 
> > 
> > The function graph tracer not only traces the start of a function
> > (uses the function tracer part for that) but also uses the kprobes
> > trick to replace the return address with a hook to trace the exit
> > of the function.
> 
> You use the "kprobes trick", but none of the kprobes code (AFAICS).
> Couldn't there be some common code between the two?

I'm not 100% sure how kprobes work, but I believe they use traps. And then 
they set the return address to take another trap, to fix it. I could be 
totally off here, on how kprobes does this.

But ftrace is about executing the code directly. The return code jumps to 
a another function in asm that will set up the call to do the tracing, and 
then fix the return pointer back. The only thing that is similar between
the two approaches that I can tell, is that we both modify the return 
address of the function. I took a quick peek at the kprobes code and I 
see no easy way to share it.

-- Steve

