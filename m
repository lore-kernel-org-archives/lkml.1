Return-Path: <linux-kernel-owner+w=401wt.eu-S1765964AbYETOQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765964AbYETOQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756055AbYETOQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:16:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34621 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbYETOQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:16:28 -0400
Date: Tue, 20 May 2008 07:14:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Dave Jones <davej@redhat.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make
Message-ID: <20080520071458.707d6e90@infradead.org>
In-Reply-To: <20080520032448.GA19348@redhat.com>
References: <20080502182745.GL14976@parisc-linux.org>
	<20080501133209.2c04dad0@infradead.org>
	<20080502184922.GM14976@parisc-linux.org>
	<20080520032448.GA19348@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 23:24:48 -0400
Dave Jones <davej@redhat.com> wrote:

>  		printk(KERN_ERR "list_add corruption. next->prev
> should be " "prev (%p), but was %p. (next=%p).\n",
>  			prev, next->prev, next);
> -		BUG();
> +		WARN_ON(1);
>  	}


now that -mm has a WARN(condition, printk arguments), could we make
this use it? The advantage (apart from smaller C code) is that it puts
the printk inside the ---[ cut here ]--- which makes it more likely that
reporters (and kerneloops.org) get the actual text....

