Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967821Ab0B0E3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 23:29:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967794Ab0B0E3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 23:29:37 -0500
Date: Fri, 26 Feb 2010 20:29:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <greg@kroah.com>
cc: Markus Rechberger <mrechberger@gmail.com>, linux-usb@vger.kernel.org,
       werner@guyane.dyn-o-saur.com, Marcus Meissner <meissner@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.33 bugs (USBFS, Intel graphic)
In-Reply-To: <20100227041815.GA12956@kroah.com>
Message-ID: <alpine.LFD.2.00.1002262022090.4513@localhost.localdomain>
References: <d9def9db1002261942k27b64dd4g670dd29969c93cbf@mail.gmail.com> <20100227035639.GA11680@kroah.com> <d9def9db1002262005t6d63b902s673fb01dac228e4d@mail.gmail.com> <20100227041815.GA12956@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Feb 2010, Greg KH wrote:
> 
> Yes, and that patch didn't touch the iso frames.  That happens later on
> in the functions that were modified.  The patch should not have had any
> affect on iso transfers.  Unless I'm missing something?

Hmm. What seems to happen is that for an isochronous transfer, the buffer 
is split for each microframe. No?

So the total length may be in 'urb->actual_length', but the actual data in 
the buffer may not be contiguous, because it's created from multiple 
smaller frames, some of which might not be full length?

I dunno. That would explain the problem - actual_length is correct, but 
the 'copy_to_user()' still doesn't copy all the data, because it's 
fragmented.

		Linus
