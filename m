Return-Path: <linux-kernel-owner+w=401wt.eu-S1759617AbXFZUg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617AbXFZUg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 16:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757924AbXFZUgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 16:36:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39487 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757541AbXFZUgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 16:36:51 -0400
Date: Tue, 26 Jun 2007 13:35:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 4/5] UML - Simplify helper stack handling
Message-Id: <20070626133550.4a607fe8.akpm@linux-foundation.org>
In-Reply-To: <20070614202655.GA9647@c2.user-mode-linux.org>
References: <20070614202655.GA9647@c2.user-mode-linux.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007 16:26:55 -0400
Jeff Dike <jdike@addtoit.com> wrote:

> --- linux-2.6.21-mm.orig/arch/um/drivers/xterm.c	2007-06-13 17:13:42.000000000 -0400
> +++ linux-2.6.21-mm/arch/um/drivers/xterm.c	2007-06-13 18:44:41.000000000 -0400
> @@ -132,7 +132,7 @@ static int xterm_open(int input, int out
>  	}
>  
>  	sprintf(title, data->title, data->device);
> -	pid = run_helper(NULL, NULL, argv, NULL);
> +	pid = run_helper(NULL, NULL, argv);
>  	if (pid < 0) {
>  		err = pid;
>  		printk(UM_KERN_ERR "xterm_open : run_helper failed, "

Something's gone wrong here.  My copy of this file has

        pid = run_helper(NULL, NULL, argv, &stack);

