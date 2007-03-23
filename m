Return-Path: <linux-kernel-owner+w=401wt.eu-S1945905AbXCWOvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945905AbXCWOvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945916AbXCWOvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:51:16 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:36105 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945905AbXCWOvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:51:14 -0400
Date: Fri, 23 Mar 2007 15:51:15 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Tomas M <tomas@slax.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] [bugfix] loop.c
Message-Id: <20070323155115.89f86b3b.dada1@cosmosbay.com>
In-Reply-To: <Pine.LNX.4.64.0703231522200.5030@twin.jikos.cz>
References: <4603DE86.1090009@slax.org>
	<20070323151956.1ac6a47b.dada1@cosmosbay.com>
	<Pine.LNX.4.64.0703231522200.5030@twin.jikos.cz>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007 15:25:23 +0100 (CET)
Jiri Kosina <jikos@jikos.cz> wrote:

> On Fri, 23 Mar 2007, Eric Dumazet wrote:
> 
> > -	if (max_loop < 1 || max_loop > 256) {
> > -		printk(KERN_WARNING "loop: invalid max_loop (must be between"
> > -				    " 1 and 256), using default (8)\n");
> > +	if (max_loop < 1) {
> > +		printk(KERN_WARNING "loop: invalid max_loop (must be > 1)"
> > +				    ", using default (8)\n");
> >  		max_loop = 8;
> >  	}
> [...]
> > +	loop_dev = kmalloc(max_loop * sizeof(struct loop_device *), GFP_KERNEL);
> > +	if (!loop_dev) {
> > +		loop_dev = vmalloc(max_loop * sizeof(struct loop_device *));
> > +		if (!loop_dev)
> > +			goto out_mem;
> > +		loop_dev_vmalloced = 1;
> >  	}
> 
> Why did you remove the upper bound check for max_loop value? Now you 
> effectively allow to max_loop * sizeof(struct loop_device *) to overflow, 
> when passed value of max_loop which is large enough. Or am I just blind?

Yes, I forgot to change this, but the new limit was 16384 in my mind

MODULE_PARM_DESC(max_loop, "Maximum number of loop devices (1-16384)");

