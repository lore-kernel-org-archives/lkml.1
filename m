Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbZI2OzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbZI2OzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 10:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbZI2OzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 10:55:16 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:37811 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbZI2OzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 10:55:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sSzp96Lx9ii+nVYWBQdVLIGjbwdn8lzOWdC3pRaR1KMsB7k68cwvjcPrao034gAHpL
         ZBL9sBusMVZuqnWadzwZrXP95yGzmUpNKEQxXitY79bk0QGTleh350DbiAquYrLN5zzy
         V4T1/IMJgfZF3SlgqUnUYQeivRL+8wtTJSY4M=
Date: Tue, 29 Sep 2009 16:55:14 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Johan Hovold <jhovold@gmail.com>, Oliver Neukum <oliver@neukum.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Message-ID: <20090929145514.GF2152@localhost>
References: <20090924154023.GA27480@localhost>
 <200909242103.48562.oliver@neukum.org>
 <20090924202107.4730f2af@lxorguk.ukuu.org.uk>
 <20090924211459.GB27963@localhost>
 <4ABD020B.4040901@gandalf.sssup.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABD020B.4040901@gandalf.sssup.it>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 07:46:51PM +0200, Michael Trimarchi wrote:
> Johan Hovold wrote:
> > On Thu, Sep 24, 2009 at 08:21:07PM +0100, Alan Cox wrote:
> >> ftdi_sio is correct with low_latency set as it uses a work queue to
> >> process the packets received.
> >>     
> > AFAICT it only uses the work queue if tty_buffer_request_room fails to
> > allocate enough space. This being the exception, the completion
> > handler normally processes the packets in interrupt context and this is
> > where I get my lockdep traces (and it happens every time I hit the echo
> > or throttle paths).
> >   
> Using two urb, double buffering and schedule a tasklet to complete the
> the reading phase. The usb will use the other free urb during receiving 
> process.
> I think remove tty_latency is not a good fix.

What do you say, Alan? Should ftdi_sio be rewritten so that it actually
defers all processing, or should low_latency go?

As it stands today ftdi_sio does indeed call tty_flip_buffer_push from
interrupt context with low_latency set and that is obviously incorrect,
right?

Regards,
Johan

