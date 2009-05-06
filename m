Return-Path: <linux-kernel-owner+w=401wt.eu-S1763908AbZEFWZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763908AbZEFWZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763284AbZEFWYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 18:24:13 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:48849 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762138AbZEFWYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 18:24:11 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to force writes
Date: Thu, 7 May 2009 00:24:16 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jason Wessel <jason.wessel@windriver.com>, greg@kroah.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0905061614320.4430-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0905061614320.4430-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905070024.16982.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 6. Mai 2009 22:24:13 schrieb Alan Stern:
> On Wed, 6 May 2009, Oliver Neukum wrote:
> > Am Mittwoch, 6. Mai 2009 21:24:56 schrieb Alan Stern:
> > > On Wed, 6 May 2009, Oliver Neukum wrote:
> > >
> > > A little thought yielded the following algorithm.  It assumes there is
> > > a fixed set of URBs allocated, unlike what you have done.  Does it make
> >
> > No, it does not ;-) Your approach is more general than you think.
> > The only important constraint is that the number of URBs in flight
> > be limited. It doesn't matter when they are allocated.
>
> You're optimistically assuming that URB allocations will succeed.  I
> guess that's okay -- dropping characters when there's insufficient
> memory seems like a good thing to do.

I also have to assume submission works.

> What's the point of that "reserve_buffer" thing?  Why not just use the
> next URB's transfer buffer?

I am toying with the idea of reusing the last URB.

On a fundamental note, thinking about this in terms of numbers of URBs
is strictly speaking wrong. We need to limit data in flight. For efficiency
we should make buffers as large as possible within that limit.

	Regards
		Oliver

