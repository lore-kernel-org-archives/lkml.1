Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbYGaS4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbYGaS4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 14:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYGaS4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 14:56:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753839AbYGaS4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 14:56:12 -0400
Date: Thu, 31 Jul 2008 11:55:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: bzolnier@gmail.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for July 30
Message-Id: <20080731115538.238b5e75.akpm@linux-foundation.org>
In-Reply-To: <20080731143013.ZZRA012@mailhub.coreip.homeip.net>
References: <20080730170635.f737ffe9.sfr@canb.auug.org.au>
	<20080730231029.9818953c.akpm@linux-foundation.org>
	<20080731140708.GA11229@core.corenet.prv>
	<58cb370e0807310836x4a6e3c40rf5c3c8ec8b5caae0@mail.gmail.com>
	<20080731115301.ZZRA012@mailhub.coreip.homeip.net>
	<20080731104437.5e5669bc.akpm@linux-foundation.org>
	<20080731141302.ZZRA012@mailhub.coreip.homeip.net>
	<20080731112654.d9620b36.akpm@linux-foundation.org>
	<20080731143013.ZZRA012@mailhub.coreip.homeip.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 14:34:41 -0400
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> > > > > No. The X driver is broken. It tells kernel to use buffer bugger than
> > > > > allocated and gets its stack smashed. Tslib has also soma funkiness
> > > > > in the ioctl handling as well... *shrug*
> > > > > 
> > > > > We have a couple months to get distros updated...
> > > > > 
> > > > 
> > > > aaarrrrgggggghhh.  I don't think this is practical.  This means that
> > > > (for example) FC5 machines (of which I happen to have one) are dead. 
> > > > And lots of other older-distro-based systems.
> > > > 
> > > > Is there some userspace workaround which doesn't require an X server
> > > > update?
> > > > 
> > > > Surely it must be possible to make the kernel contiue to support these
> > > > servers?
> > > > 
> > > 
> > > Andrew,
> > > 
> > > It is not like we broke ABI here. The progam (synaptics driver) had a
> > > grave bug. Older kernels happened to paper over the bug because they
> > > did not fill the whole buffer that was advertised as available. Now
> > > that we have more data to report the bug bit us. What do you want me
> > > to do?
> > 
> > Paper over the bug again.  When it happens, spit out a loud printk.
> 
> For that we we need to be sure that the size of the buffer passed to
> us is incorrect. I.e. if we decide that 512 is a magic bad number and
> decide to limit the output then legit programs supplying 512 byte
> buffers they will not get the whole thing.

uh.  I'm still scrabbling to understand all this.  Where is the
information about this kept?  Which commit caused this problem to
occur?

It _sounds_ like userspace is passing in a buffer and is also passing
in an incorrect (too large) `size' parameter, yes?

This is an ioctl interface?  Could we leave the old ioctl unchanged and
introduce the offending changes into a new ioctl number?

> > 
> > > Synaptics driver is a small package and takes 2 minutes to recompile.
> > > You don't have to update entire X server with it (in fact I don't think
> > > it is even part of X distribution because it is GPL).
> > 
> > What proportion of the X servers out there did we just break?
> > 
> > Was the crash I saw due to this?
> > 
> > Where would I (Aunt Tillie running FC5) go to find out how to fix my
> > machine up again? 
> 
> What is Aunt Tillie doing compiling her own kernels on FC5? You
> OTOH managed to get an answer fairly quickly ;)

I'll ask again: where do our users go to find out how to make their X
server work again?  If the answer is "nowhere" then can we please at 
least write up a simple step-by-step repair procedure, as we'll surely
be needing it a lot.

