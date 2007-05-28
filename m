Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbXE1MC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbXE1MC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 08:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbXE1MCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 08:02:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52540 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbXE1MCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 08:02:49 -0400
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before
	hibernation/suspend
From: Kay Sievers <kay.sievers@vrfy.org>
To: Michael-Luke Jones <mlj28@cam.ac.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Rob Landley <rob@landley.net>
In-Reply-To: <5C7E12A9-DCEB-40AA-B3E6-4A54F4FE8047@cam.ac.uk>
References: <200705272229.21263.rjw@sisk.pl>
	 <20070527220412.GC22687@srcf.ucam.org>
	 <1180304166.3131.66.camel@lov.localdomain> <200705280943.54312.rjw@sisk.pl>
	 <9D3FC259-8391-4C2F-9F0F-AEF6CB3030E8@cam.ac.uk>
	 <1180343171.4242.15.camel@lov.localdomain>
	 <5C7E12A9-DCEB-40AA-B3E6-4A54F4FE8047@cam.ac.uk>
Content-Type: text/plain
Date: Mon, 28 May 2007 14:01:40 +0200
Message-Id: <1180353701.4242.68.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19FqxCHdZBfnwExMzVBBXOjmYRas1ULojTZenO
 OuQhRPnF/AtqQJnpx8oy02Mn6GYc0LYXv2RrE1m/flLPddNl8t
 4HUvspYdAy9YL9O0soLN7XptDdxgzqw
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-28 at 11:26 +0100, Michael-Luke Jones wrote:
> On 28 May 2007, at 10:06, Kay Sievers wrote:
> 
> > The underlying issue are the driver authors, that's not so easy to
> > fix. :)
> 
> Sorry, I know this maybe be unintentional, but comments like this  
> make me somewhat angry.

It was the response to "pushing a bodge upstream", while we just try to
make things working. :)
We are fighting that broken firmware-loader model for years, but every
driver author seems to have its own idea how that should work in theory,
but they are not even willing to switch to the existing version that is
expected to work better.

> If there is no decent documentation as to how to do it the right way  
> (tm), how do you expect people to do it the right way (tm)?
> 
> > Any timeout for a
> > firmware-request is just a broken concept, the request should wait
> > forever, to be fulfilled or canceled from userspace when it's ready.
> 
> What I wrote above is especially true when the in-kernel APIs  
> themselves do things the wrong way (tm) themselves. Thus, even more  
> thought is required to work around this imperfect behaviour in a sane  
> manner. And without documentation, every single device driver author  
> has to go through this thought process themselves. Unsurprisingly,  
> they often get it wrong. But as there's no decent documentation to do  
> it right, it's *not* their fault. I'd suggest it's more the fault of  
> the core kernel devs who fail to fix up a questionable firmware  
> loading interface, then fail to document how to work around its  
> shortcomings.
> 
> Again, apologies if this sounds angry, I don't want to start an  
> argument. But as someone just starting out here, this kind of thing  
> can be very frustrating, as even with the best will in the world,  
> achieving the right way (tm) is basically impossible if those in the  
> know about what the right way (tm) is fail to share this information.

In our development model, users of an interface are expected to improve
it, because nobody else really knows what's needed. That unfortunately
didn't happen so far.

We get this kind of conversation every few months since a few years now.
I wonder, if we will see code, or at least come up with a better idea
this time. :)

Kay

