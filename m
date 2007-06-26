Return-Path: <linux-kernel-owner+w=401wt.eu-S1758972AbXFZVx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972AbXFZVx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 17:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbXFZVxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 17:53:50 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:39481 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbXFZVxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 17:53:50 -0400
Date: Tue, 26 Jun 2007 17:53:28 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [uml-devel] [PATCH 4/5] UML - Simplify helper stack handling
Message-ID: <20070626215328.GA23077@c2.user-mode-linux.org>
References: <20070614202655.GA9647@c2.user-mode-linux.org> <20070626133550.4a607fe8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626133550.4a607fe8.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 01:35:50PM -0700, Andrew Morton wrote:
> >  	sprintf(title, data->title, data->device);
> > -	pid = run_helper(NULL, NULL, argv, NULL);
> > +	pid = run_helper(NULL, NULL, argv);
> >  	if (pid < 0) {
> >  		err = pid;
> >  		printk(UM_KERN_ERR "xterm_open : run_helper failed, "
> 
> Something's gone wrong here.  My copy of this file has
> 
>         pid = run_helper(NULL, NULL, argv, &stack);

Looks like you're applying patches out of order.  This is from the
14th, while a patch from the 13th ("UML - xterm driver tidying") has
-       pid = run_helper(NULL, NULL, argv, &stack);
	...
+       pid = run_helper(NULL, NULL, argv, NULL);

If you don't want to fiddle with this, just drop it and I'll rediff
against the next -mm and resend.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
