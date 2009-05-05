Return-Path: <linux-kernel-owner+w=401wt.eu-S932139AbZEEKot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbZEEKot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 06:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbZEEKoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 06:44:09 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:34382 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbZEEKn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 06:43:57 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] usb: use memdup_user()
Date: Tue, 5 May 2009 12:44:01 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: David Brownell <david-b@pacbell.net>, Li Hong <lihong.hi@gmail.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <3a3680030905030900x672af596mc2ebc3c38f119c92@mail.gmail.com> <200905041601.51789.oliver@neukum.org> <20090504231157.1ff2cf15.akpm@linux-foundation.org>
In-Reply-To: <20090504231157.1ff2cf15.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905051244.01698.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 5. Mai 2009 08:11:57 schrieb Andrew Morton:
> On Mon, 4 May 2009 16:01:51 +0200 Oliver Neukum <oliver@neukum.org> wrote:

> > I want people to be forced to think about memory allocations.
> > We had endless trouble during 2.4 with storage deadlocking.
> > We simply need full control of this.
>
> thou-shalt-use-GFP_NOFS is a very common pattern in many filesystems.
> And thou-shalt-use-GFP_NOIO is a very common pattern in block drivers.

USB drivers are interface level yet some functions, reset and power
management, are on a device level. As it is unpredictable whether
a driver will share a device with a storage driver, all USB drivers as far as
these functions are concerned must be considered block device drivers.
That's the reason GFP_NOIO is so prevalent in USB.

> I wonder how hard it would be to add runtime debugging checks?  If

I'd prefer compile time checks. Ideally we'd annotate a function with an
attribute making the compiler barf if copy_to/from_user or an inappropriate
kmalloc is used. It can't be perfect due to function pointers, but it would
be a good start.

	Regards
		Oliver

