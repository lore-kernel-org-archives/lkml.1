Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145Ab0B0FRX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 00:17:23 -0500
Received: from kroah.org ([198.145.64.141]:54982 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab0B0FRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 00:17:22 -0500
Date: Fri, 26 Feb 2010 21:17:37 -0800
From: Greg KH <greg@kroah.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-usb@vger.kernel.org,
       werner@guyane.dyn-o-saur.com, Marcus Meissner <meissner@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.33 bugs (USBFS, Intel graphic)
Message-ID: <20100227051737.GA14976@kroah.com>
References: <d9def9db1002261942k27b64dd4g670dd29969c93cbf@mail.gmail.com> <20100227035639.GA11680@kroah.com> <d9def9db1002262005t6d63b902s673fb01dac228e4d@mail.gmail.com> <20100227041815.GA12956@kroah.com> <alpine.LFD.2.00.1002262022090.4513@localhost.localdomain> <d9def9db1002262034p55cd569n6c423741c276798d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db1002262034p55cd569n6c423741c276798d@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 05:34:27AM +0100, Markus Rechberger wrote:
> On Sat, Feb 27, 2010 at 5:29 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> >
> > On Fri, 26 Feb 2010, Greg KH wrote:
> >>
> >> Yes, and that patch didn't touch the iso frames. ?That happens later on
> >> in the functions that were modified. ?The patch should not have had any
> >> affect on iso transfers. ?Unless I'm missing something?
> >
> > Hmm. What seems to happen is that for an isochronous transfer, the buffer
> > is split for each microframe. No?
> >
> 
> exactly. and each microframe has its own buffer length identifier.
> 
> the current behaviour breaks VMware, QEMU and virtualbox .. probably
> other things too.
> 
> 
> > So the total length may be in 'urb->actual_length', but the actual data in
> > the buffer may not be contiguous, because it's created from multiple
> > smaller frames, some of which might not be full length?
> >
> 
> yes, it's only contiguous for BULK.
> 
> > I dunno. That would explain the problem - actual_length is correct, but
> > the 'copy_to_user()' still doesn't copy all the data, because it's
> > fragmented.
> >
> 
> no you got it, but your patch does not work. The best way would be to
> revert it if someone wants to speed up BULK it should go down another
> path, leaving the old working implementation untouched.

Hm, so it's back to the original idea of just doing a kzalloc of the
initial buffer, that should solve the problem that Marcus found.

I'll go dig that back up and if you could test it, that would be most
appreciated.

thanks,

greg k-h
