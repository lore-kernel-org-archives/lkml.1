Return-Path: <linux-kernel-owner+w=401wt.eu-S1759854AbZEFNe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759854AbZEFNe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 09:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbZEFNes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 09:34:48 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:33612 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbZEFNer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 09:34:47 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] usb: use memdup_user()
Date: Wed, 6 May 2009 15:34:52 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: David Brownell <david-b@pacbell.net>, Li Hong <lihong.hi@gmail.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <3a3680030905030900x672af596mc2ebc3c38f119c92@mail.gmail.com> <200905051244.01698.oliver@neukum.org> <20090505102253.6993f381.akpm@linux-foundation.org>
In-Reply-To: <20090505102253.6993f381.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905061534.53521.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 5. Mai 2009 19:22:53 schrieb Andrew Morton:
> On Tue, 5 May 2009 12:44:01 +0200 Oliver Neukum <oliver@neukum.org> wrote:

> > USB drivers are interface level yet some functions, reset and power
> > management, are on a device level. As it is unpredictable whether
> > a driver will share a device with a storage driver, all USB drivers as
> > far as these functions are concerned must be considered block device
> > drivers. That's the reason GFP_NOIO is so prevalent in USB.
>
> There must be some particular action which flips the thread of control
> from one state to the other.  eg, taking of a lock.

Basically assigning an interface to the storage or ub driver.

> > > I wonder how hard it would be to add runtime debugging checks?  If
> >
> > I'd prefer compile time checks. Ideally we'd annotate a function with an
> > attribute making the compiler barf if copy_to/from_user or an
> > inappropriate kmalloc is used. It can't be perfect due to function
> > pointers, but it would be a good start.
>
> I don't think that would have enough coverage - bugs in this area tend
> to come from calling some function which looks innocent, but which
> calls some function which calls some function which calls some function
> which uses GFP_KERNEL.
>
> And then there's stuff like "usb takes a mutex which is also taken by
> some other thread which does a GFP_KERNEL allocation while holding that
> mutex".

Yes, but to catch that you'd have to teach lockdep about those functions
whose locks are dangerous to share with respect to memory allocation.
Is there another way to do that besides labelling dangerous methods?

	Regards
		Oliver


