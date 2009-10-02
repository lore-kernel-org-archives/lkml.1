Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbZJBIr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbZJBIr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 04:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757356AbZJBIr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 04:47:58 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:5632 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbZJBIr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 04:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nw7q1vnKU4/4grf1OgMIoJT5tXoJPU7UWW3pUpU6/WZkUjsciWbUEn6FVVXxzBcvCB
         xsdBH0CXvlx9LuhR95vZm4OoJEa5dCXlAJzJr2LiwnFdnCVqljWItwLgFnEKsE/1qERS
         ExtdC2z8JaIrEVKSj7CC9UM8khBpORcfgOz0A=
Date: Fri, 2 Oct 2009 10:47:55 +0200
From: Johan Hovold <jhovold@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Johan Hovold <jhovold@gmail.com>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Message-ID: <20091002084755.GA7382@localhost>
References: <20090924154023.GA27480@localhost>
 <200909242103.48562.oliver@neukum.org>
 <20090924202107.4730f2af@lxorguk.ukuu.org.uk>
 <20090924211459.GB27963@localhost>
 <4ABD020B.4040901@gandalf.sssup.it>
 <20090929145514.GF2152@localhost>
 <20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
 <m163ayzevu.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m163ayzevu.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 07:52:21PM -0700, Eric W. Biederman wrote:
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

It's the same problem.

Greg, can't we apply the patch for stable at least? Then we can massage
ftdi_sio into actually using the work queue for doing _all_ processing
in the meantime if deemed necessary.

Alan, did you have time to look at it? Are there any reasons for wanting
to keep low_latency in ftdi_sio when it was removed from all other
drivers processing in interrupt context (without doing work queue
re-implementations)?

Thanks,
Johan

