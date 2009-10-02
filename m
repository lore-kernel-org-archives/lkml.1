Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbZJBJDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbZJBJDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZJBJDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:03:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44475 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753087AbZJBJDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:03:48 -0400
Date: Fri, 2 Oct 2009 10:04:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Johan Hovold <jhovold@gmail.com>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb@vger.kernel.org, Alan Cox <alan@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Message-ID: <20091002100430.58785957@lxorguk.ukuu.org.uk>
In-Reply-To: <m163ayzevu.fsf@fess.ebiederm.org>
References: <20090924154023.GA27480@localhost>
	<200909242103.48562.oliver@neukum.org>
	<20090924202107.4730f2af@lxorguk.ukuu.org.uk>
	<20090924211459.GB27963@localhost>
	<4ABD020B.4040901@gandalf.sssup.it>
	<20090929145514.GF2152@localhost>
	<20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
	<m163ayzevu.fsf@fess.ebiederm.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Oct 2009 19:52:21 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> >> As it stands today ftdi_sio does indeed call tty_flip_buffer_push from
> >> interrupt context with low_latency set and that is obviously incorrect,
> >> right?
> >
> > It seems to do it from a work queue - or did I miss a case ?
> 
> ftdi_sio crash quite regularly for me with 2.6.31.
> 
> With a bunch of nasties like:
> BUG: scheduling while atomic: swapper/0/0x00010000
> bad: scheduling from the idle thread!
> 
> I don't know if I have a good backtrace as things
> scrolled away faster than they were captured
> but the code below looks like it may be.

So it is indeed wrong. Removing the tty->low_latency = 1 will fix the
crash and probably should go for stable. I'll have a deeper look at what
is doing with the rest of the stuff as the driver may just be trying to
be far cleverer than it needs with the newer buffer code.

Alan
