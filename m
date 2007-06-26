Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbXFZWIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbXFZWIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 18:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757289AbXFZWIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 18:08:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51933 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757224AbXFZWIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 18:08:02 -0400
Date: Tue, 26 Jun 2007 15:07:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [uml-devel] [PATCH 4/5] UML - Simplify helper stack handling
Message-Id: <20070626150747.5110e614.akpm@linux-foundation.org>
In-Reply-To: <20070626215328.GA23077@c2.user-mode-linux.org>
References: <20070614202655.GA9647@c2.user-mode-linux.org>
	<20070626133550.4a607fe8.akpm@linux-foundation.org>
	<20070626215328.GA23077@c2.user-mode-linux.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 17:53:28 -0400
Jeff Dike <jdike@addtoit.com> wrote:

> On Tue, Jun 26, 2007 at 01:35:50PM -0700, Andrew Morton wrote:
> > >  	sprintf(title, data->title, data->device);
> > > -	pid = run_helper(NULL, NULL, argv, NULL);
> > > +	pid = run_helper(NULL, NULL, argv);
> > >  	if (pid < 0) {
> > >  		err = pid;
> > >  		printk(UM_KERN_ERR "xterm_open : run_helper failed, "
> > 
> > Something's gone wrong here.  My copy of this file has
> > 
> >         pid = run_helper(NULL, NULL, argv, &stack);
> 
> Looks like you're applying patches out of order.

Yes, I am.  After a few days off and a few more days being lazy I have
600-odd patches (and followups thereto) to process.

- If I do them in-order, I merge stuff which is out of date or wrong

- If I do them in reverse-order, I can miss dependencies.

On balance, reverse-order seems to be better.

>  This is from the
> 14th, while a patch from the 13th ("UML - xterm driver tidying") has
> -       pid = run_helper(NULL, NULL, argv, &stack);
> 	...
> +       pid = run_helper(NULL, NULL, argv, NULL);
> 
> If you don't want to fiddle with this, just drop it and I'll rediff
> against the next -mm and resend.

I sorted it out, thanks.
