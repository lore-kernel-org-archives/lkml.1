Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbZJKPyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbZJKPyK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 11:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbZJKPyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 11:54:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37271 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752432AbZJKPyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 11:54:08 -0400
Date: Sun, 11 Oct 2009 16:54:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vincent Sanders <vince@simtec.co.uk>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC] [PATCH] drivers/scsi/ch.c: Remove BKL in ch_open
Message-ID: <20091011165408.51d4f413@lxorguk.ukuu.org.uk>
In-Reply-To: <20091011082917.6ebbd810@infradead.org>
References: <alpine.LFD.2.00.0910111443400.3587@localhost.localdomain>
	<20091011153709.4438cf9c@lxorguk.ukuu.org.uk>
	<20091011082917.6ebbd810@infradead.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm not so sure. In fact there are some quite umm interesting
> > questions about this code, and some of them are shared with other
> > modules too.
> > 
> > Consider the following sequence
> > 
> > 		CPU1				CPU2
> > 	register_chrdev
> > 		ok
> > 						open device
> > 						takes lock
> 
> 
> but open does not take the BKL, so the BKL is not protecting you at
> all against this..

But module load/unload does - so while the change doesn't appear to cause
any problems there is an underlying problem here that wants looking at.
