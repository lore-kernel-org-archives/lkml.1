Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbZGUQbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbZGUQbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755670AbZGUQbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:31:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43176 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755629AbZGUQbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:31:40 -0400
Date: Tue, 21 Jul 2009 17:32:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090721173247.158a6292@lxorguk.ukuu.org.uk>
In-Reply-To: <20090721162312.GA25151@tango.0pointer.de>
References: <20090702113529.4896.2321.stgit@t61.ukuu.org.uk>
	<20090721162312.GA25151@tango.0pointer.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sounds good to me. Though tbh, in my eyes the "proper" fix for this
> whole problem would be something which would enable userspace to
> poll() for VT changes. Having blocking ioctl()s still requires most

The question there is what device do you poll(). It's easy enough to
magic up a separate vtevent device I guess.

> userspace applications to spawn a thread for doing that since usually
> they are not exclusively waiting for VT events, but also for dbus
> requests or some other events.
> 
> But OTOH I guess 2 threads are still better than the old situation
> requiring processes to run 64 threads for listening for VT changes.
> 
> Oh, and one more note: instead of padding the struct it would probably
> be more future-proof to simply pass the struct size in addition to the
> struct to the ioctl().

Padding is a lot simpler and less likely to cause bugs later
(typecasting, mischecking of sizes etc). For the kernel I favour
simplicity. A vtevent poll/read interface would be even cleaner so I will
think about that a bit further.

Alan
