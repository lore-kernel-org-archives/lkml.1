Return-Path: <linux-kernel-owner+w=401wt.eu-S965421AbYDVOaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965421AbYDVOaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965337AbYDVO36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:29:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55606 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965327AbYDVO35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:29:57 -0400
Date: Tue, 22 Apr 2008 07:29:33 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Reuben Farrelly <reuben-linuxkernel@reub.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: StackProtector Oopses - Re: 2.6.25-mm1
Message-ID: <20080422072933.751fe86f@laptopd505.fenrus.org>
In-Reply-To: <20080422083408.GB28970@elte.hu>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	<48089BDE.6040100@reub.net>
	<20080418133645.GF31797@elte.hu>
	<4808B4EF.8030901@reub.net>
	<20080421150604.GH5474@elte.hu>
	<20080421184859.48efcb67@laptopd505.fenrus.org>
	<20080422083408.GB28970@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2008 10:34:08 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > > yeah. Arjan - any new patches to try that might fix the bootup
> > > test?
> > 
> > I've looked at the disassembly and compared it to mine, and the gcc
> > is doing something... rather unexpected. The only thing I can think
> > of is the patch below, it should make it a ton more robust...
> 
> > -	memset(&foo, 0, 2*sizeof(foo)); /* deliberate buffer
> > overflow */
> > +	if (current->stack_canary == *(((unsigned long *)&foo)+1))
> > +		*(((unsigned long *)&foo)+1) = 0;
> > +	else
> > +		printk(KERN_ERR "No -ftack-protector canary
> > found\n");
> 
> ok, i queued this up. (with the typo that Valdis noticed fixed)
> 
> but ... this bug needs to be figured out, not worked around.

well what I figured out was that the stack layout was "different".
Why/how I don't know, but being more robust against that is a good idea
in general.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
