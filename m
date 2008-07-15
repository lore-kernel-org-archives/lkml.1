Return-Path: <linux-kernel-owner+w=401wt.eu-S1761275AbYGOCJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761275AbYGOCJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbYGOCJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:09:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752847AbYGOCJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:09:33 -0400
Date: Mon, 14 Jul 2008 19:08:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: david@lang.hm
cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <alpine.DEB.1.10.0807141805300.14223@asgard.lang.hm>
Message-ID: <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org>
 <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141756361.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807141805300.14223@asgard.lang.hm>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, david@lang.hm wrote:

> On Mon, 14 Jul 2008, Linus Torvalds wrote:
> > 
> > That's a totally bogus argument.
> 
> you misunderstood me. the people pushing request_firmware() are doing so on
> the basis that they won't have to use kernel ram to hold the firmware. the
> people pushing for having the option of building the firmware into the module
> are acknowleding that this may use a little more ram, but they see it as being
> more reliable.

I'm just saying that it's a totally bogus argument to claim that it takes 
less memory - Either way.

As to reliability, I don't buy that, especially with a generic interface, 
and with a way to link the thing in-kernel anyway. Using common 
infrastructure is going to be more reliable.

> > I don't know why people get confused about this. I suspect that people
> > kind of expect that since they need to reload the firmware when resuming
> > the device, they should also do the "request_firmware()" at resume time.
> 
> according to David W they would, becouse the driver would not keep the
> firmware in kernel memory after it's initialized

And if so, David W is a total moran, and shouldn't have been doing this.

The fact is, there _are_ good arguments for request_firmware(), but they 
have nothing what-so-ever to do with memory use or anything like that.

The argument for request_firmware() is that it's a good _single_ interface 
to the whole firmware issue, allowing us to split up the driver from the 
firmware without every driver having to do some hack of its own.

Not memory use.

So next time you see somebody arguing about memory use (either way), just 
slap them, and tell them Linus told you to.

			Linus
