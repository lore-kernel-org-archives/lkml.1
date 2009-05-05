Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbZEEIvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbZEEIvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 04:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbZEEIuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 04:50:50 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:55843 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbZEEIut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 04:50:49 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] usb: use memdup_user()
Date: Tue, 5 May 2009 10:50:52 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       David Brownell <david-b@pacbell.net>, Li Hong <lihong.hi@gmail.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <3a3680030905030900x672af596mc2ebc3c38f119c92@mail.gmail.com> <84144f020905040041n721336a0t4c0f4c25eb272abf@mail.gmail.com> <20090504145348.GA10545@kroah.com>
In-Reply-To: <20090504145348.GA10545@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905051050.52768.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 4. Mai 2009 16:53:48 schrieb Greg KH:
> > On Mon, May 4, 2009 at 10:02 AM, David Brownell <david-b@pacbell.net> 
wrote:
> > > Unless it's incorrect to use that, I have to say that it
> > > makes more sense to use that utility than recreate it by
> > > open-coding...
> >
> > Yup, and I don't really see how anyone can avoid "thinking about a new
> > primitive" anyway. We have it in the kernel now and surely it will
> > appear under drivers/usb/ sooner or later...
>
> Well, how about passing the GPF flags down to memdup_user() so that we
> can use it in the usb subsystem, and Oliver's complaint will be resolve?

It would always be GFP_KERNEL. Unless you can use GFP_KERNEL you must
not use copy_to/from_user. It would not make sense for all other users of that
API. I don't think that the API as such is bad, just that USB needs extra care
with memory allocations (and user memory access)

We are limited to GFP_NOIO during pre/post_reset and suspend/resume
and while we hold any locks these methods take. This is not simple and
people need to be reminded.

	Regards
		Oliver

