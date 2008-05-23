Return-Path: <linux-kernel-owner+w=401wt.eu-S1756977AbYEWLRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbYEWLRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 07:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbYEWLRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 07:17:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50560 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752248AbYEWLRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 07:17:44 -0400
Date: Fri, 23 May 2008 12:04:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] snapshot: Push BKL down into ioctl handlers
Message-ID: <20080523120452.6feefed0@core>
In-Reply-To: <200805230309.53136.rjw@sisk.pl>
References: <20080522222500.0f5873ff@core>
	<200805230309.53136.rjw@sisk.pl>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  
> > +	lock_kernel();
> > +
> 
> Hm, well, I admit I'm a bit ignorant as far as the chardev locking is
> concerned, but can you please tell me why would that be wrong if we didn't call
> lock_kernel() here at all?

I've just been pushing the lock down. If the code already has enough
internal locking for things like multiple ioctls in parallel then you can
probably kill it entirely - but that needs someone who knows that driver
well to decide and evaluate.
