Return-Path: <linux-kernel-owner+w=401wt.eu-S1762144AbYGOSMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762144AbYGOSMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbYGOSLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:11:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39837 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbYGOSLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:11:54 -0400
Message-ID: <487CE85D.8050107@garzik.org>
Date: Tue, 15 Jul 2008 14:11:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: david@lang.hm, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141756361.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807141805300.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org> <487C585C.2060002@garzik.org> <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org> <487CD7FE.9010209@garzik.org> <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org> <487CDEC0.3090004@garzik.org> <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org> <alpine.LFD.1.10.0807151042170.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807151042170.3017@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 15 Jul 2008, Linus Torvalds wrote:
>> This is the "I'm too stupid to live" argument. I've already answered that. 
>> What's so hard with "make firmware_install"?
> 
> Btw, that is by no means the only way to handle it either. As I said in 
> other emails - about trying to find _productive_ questions to answer - 
> maybe we could also just install it in the modules directory or some 
> similar per-kernel location, and just teach request_firmware() to load 
> binary blobs directly.
> 
> Then - horror of horrors - we could even make "make modules_install" do 
> things like that automatically for you with some Makefile rule trickery.
> 
> See? There are _productive_ things you can do or ask others to do.
> 
> But singing the same "I'm so stupid that I cannot install the firmware" 
> song over and over again doesn't make me think you are worth listening to.

Can't you see that changing build processes takes time?  Fixing driver 
disk creation tools take time?  Validating that each driver is packaged 
with its correct firmware takes time?

With each driver converted, it is entirely possible that all users are 
completely unaware that it even had a firmware, much less that it now 
needs 'make firmware_install' to continue working.

If one is completely unaware of a driver's firmware need, (a) you don't 
know you need to install it and (b) you don't find out you need it until 
you boot and the driver fails to work.

I am trying to work to minimize (a) and (b) here, because as deployed, 
there are large chances for failure here, across a random selection of 
drivers.

	Jeff


P.S.  AFAIK, 'make modules_install' installs firmware, unless that 
change was not pushed upstream.

