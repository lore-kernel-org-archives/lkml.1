Return-Path: <linux-kernel-owner+w=401wt.eu-S932416AbXGQH0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbXGQH0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761540AbXGQH0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:26:36 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:22607 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757406AbXGQH0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:26:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=ZS1Oxe7VfNOc/GtShjuQD3yaPdU4ClRSL8GmM8yBZeN0MiskvGFoRZm8W8eB/LW/fpcyp/9O9auroG6/GfugTL+wxPlrJDCEYn0Rir+Nmj3YVViFXuyjj4lSOHaVkordVayppuZrsu1eRKcKL2CMZE80w48m8Un9xXGRCClx9Lc=
Date: Tue, 17 Jul 2007 03:26:01 -0400
To: david@lang.hm
Cc: Joseph Fannin <jfannin@gmail.com>, Oliver Neukum <oliver@neukum.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: Hibernating To Swap Considered Harmful
Message-ID: <20070717072601.GA21633@nineveh.local>
Mail-Followup-To: david@lang.hm, Joseph Fannin <jfannin@gmail.com>,
	Oliver Neukum <oliver@neukum.org>,
	Jeremy Maitin-Shepard <jbms@cmu.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Huang, Ying" <ying.huang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
	linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <200707121453.49616.rjw@sisk.pl> <87odig1idx.fsf@jbms.ath.cx> <20070717001239.GB20082@nineveh.local> <200707170744.08191.oliver@neukum.org> <20070717062803.GA9069@nineveh.local> <Pine.LNX.4.64.0707162338370.19248@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707162338370.19248@asgard.lang.hm>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: jfannin@gmail.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 11:42:08PM -0700, david@lang.hm wrote:
> On Tue, 17 Jul 2007, Joseph Fannin wrote:

> >root is free to "dd if=/dev/random of=/dev/mem".  Root owned
> >daemons which do bad things are bugs.
>
> in this case it would be more like
>
> dd if=/block0 of=/dev/sda1 count=1 bs=4096 skip=5000
> dd if=/block1 of=/dev/sda1 count=1 bs=4096 skip=5050
> dd if=/block2 of=/dev/sda1 count=1 bs=4096 skip=5400
> etc
>
> to write the blocks to the raw parition in the right place

What I meant by that was that root is allowed to shoot himself in the
foot.  Nothing stops root from opening a swap/hibernate file, which
would put it in cache, and cause it to be inconsistant if a
hibernation image was written to it behind the kernel's back.

That would be a very stupid thing to do, however.  There's no reason
to open that file, unless you know *exactly* what you are doing, in
which case the onus is on you to get it right.

But you have a point.  The swap file could be very fragmented.  It
might often be so, even.

Still, is this better than exporting the kernel's swap internals
(which has never been a public interface before)?

Does it make the interface that writing hibernation images to swap
imposes any better?

Even if hibernation files are no less complicated to support than
hibernating to swap files (which isn't a forgone conclusion) , there
are plenty of reasons writing hibernation images to swap doesn't make
sense.


> >Again, supporting swap files (*which is not optional*) requires the
> >very same support.
>
> in the kexec model why would the second kernel care about swap files at
> all? (unles it chooses to write to them, in which case it is exactly the
> same support, but unless it writes to them it doesn't need to care)

My point is that no extra work is required to write hibernation images
to dedicated files than to write hibernation images to swap files.

If swap files are to be supported, then, there's no technical reason
not to support dedicated hibernation files.  Dedicated hibernation
files are better, and there's no reason not to implement them.


--
Joseph Fannin
jfannin@gmail.com

