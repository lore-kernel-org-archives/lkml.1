Return-Path: <linux-kernel-owner+w=401wt.eu-S1752074AbXISAHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbXISAHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 20:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbXISAHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 20:07:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42828 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812AbXISAHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 20:07:48 -0400
Date: Tue, 18 Sep 2007 17:07:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH] UML - Fix irqstack crash
Message-Id: <20070918170733.c6399124.akpm@linux-foundation.org>
In-Reply-To: <20070918233336.GA9746@c2.user-mode-linux.org>
References: <20070918233336.GA9746@c2.user-mode-linux.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 19:33:36 -0400
Jeff Dike <jdike@addtoit.com> wrote:

> ===================================================================
> --- linux-2.6.17.orig/arch/um/os-Linux/signal.c	2007-09-09 11:15:37.000000000 -0400
> +++ linux-2.6.17/arch/um/os-Linux/signal.c	2007-09-18 12:32:40.000000000 -0400
> @@ -119,7 +119,7 @@ void (*handlers[_NSIG])(int sig, struct 
>  
>  void handle_signal(int sig, struct sigcontext *sc)
>  {
> -	unsigned long pending = 0;
> +	unsigned long pending = 1 << sig;

You want 1UL there.
