Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbZJKQTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbZJKQTO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 12:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbZJKQTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 12:19:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:39246 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbZJKQTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 12:19:12 -0400
Date: Sun, 11 Oct 2009 09:19:04 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vincent Sanders <vince@simtec.co.uk>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC] [PATCH] drivers/scsi/ch.c: Remove BKL in ch_open
Message-ID: <20091011091904.60a64279@infradead.org>
In-Reply-To: <20091011171403.13a018f0@lxorguk.ukuu.org.uk>
References: <alpine.LFD.2.00.0910111443400.3587@localhost.localdomain>
	<20091011153709.4438cf9c@lxorguk.ukuu.org.uk>
	<20091011082917.6ebbd810@infradead.org>
	<20091011165408.51d4f413@lxorguk.ukuu.org.uk>
	<20091011090313.1b8f0eb1@infradead.org>
	<20091011171403.13a018f0@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Oct 2009 17:14:03 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > But module load/unload does
> > 
> > it does?
> > 
> > looking at the code.... so far failing to find where.
> 
> Interesting - it used to and there is code that still relies on that.

I can't find that to be the case anymore though

> 
> The more general problem of
> 
> 	register_chrdev
> 					open
> 	do something
> 	error
> 	unload
> 					whoops
> 
> definitely needs looking at however.

absolutely

we used to have the same issue with networking devices,
and there it ended up with a split "allocate" and "register"




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
