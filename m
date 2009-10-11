Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbZJKRJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbZJKRJn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 13:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbZJKRJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 13:09:42 -0400
Received: from vena.lwn.net ([206.168.112.25]:38457 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756888AbZJKRJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 13:09:41 -0400
Date: Sun, 11 Oct 2009 11:09:19 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, John Kacur <jkacur@redhat.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vincent Sanders <vince@simtec.co.uk>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC] [PATCH] drivers/scsi/ch.c: Remove BKL in ch_open
Message-ID: <20091011110919.559da63d@tpl.lwn.net>
In-Reply-To: <20091011091904.60a64279@infradead.org>
References: <alpine.LFD.2.00.0910111443400.3587@localhost.localdomain>
	<20091011153709.4438cf9c@lxorguk.ukuu.org.uk>
	<20091011082917.6ebbd810@infradead.org>
	<20091011165408.51d4f413@lxorguk.ukuu.org.uk>
	<20091011090313.1b8f0eb1@infradead.org>
	<20091011171403.13a018f0@lxorguk.ukuu.org.uk>
	<20091011091904.60a64279@infradead.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Oct 2009 09:19:04 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> > The more general problem of
> > 
> > 	register_chrdev
> > 					open
> > 	do something
> > 	error
> > 	unload
> > 					whoops
> > 
> > definitely needs looking at however.  
> 
> absolutely
> 
> we used to have the same issue with networking devices,
> and there it ended up with a split "allocate" and "register"

Char devs are really the same way - request_chrdev_region() and
cdev_add().  I've thought for a while that register_chrdev() should be
seen as a legacy interface and removed - LDD3 was written from that
point of view.  But that takes work, and nobody's found the issue
urgent enough to put time into...

jon
