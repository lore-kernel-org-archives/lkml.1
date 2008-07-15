Return-Path: <linux-kernel-owner+w=401wt.eu-S1760778AbYGOAhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778AbYGOAhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 20:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757421AbYGOAhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 20:37:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56326 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497AbYGOAhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 20:37:05 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: david@lang.hm
Cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714165956.7fe2d4ee@infradead.org>
	 <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 17:36:53 -0700
Message-Id: <1216082213.27455.109.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 17:06 -0700, david@lang.hm wrote:
> On Mon, 14 Jul 2008, Arjan van de Ven wrote:
> 
> > On Mon, 14 Jul 2008 16:41:19 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >> On Mon, 14 Jul 2008 16:23:26 -0700
> >> David Woodhouse <dwmw2@infradead.org> wrote:
> >>
> >>> Linus, please pull from the for-2.6.27 branch of:
> >>> 	git://git.infradead.org/users/dwmw2/firmware-2.6.git
> >>> for-2.6.27
> >>
> >> The firmware flamewars seem to have subsided lately.  Is everyone
> >> happy with this now?
> >>
> >
> > this seems to have left the contentious pieces out....
> 
> almost, the one thing that this could have done would be to offer an 
> option to bundle the firmware with the module. currently it offers the 
> option to load the firmware at the same time as the module, not _quite_ 
> the same thing.

I see no real point in that. If you have userspace to load modules, then
you have userspace to load firmware.

We made 'make modules_install' install the firmware in /lib/firmware for
you at the same time as it installs the modules, to avoid problems if
people forgot to run 'make firmware_install'. That really ought to be
enough.

I know Jeff complained that it wasn't, and insisted that he _needed_ to
be able to scp a single .ko file around which contained both, and the
world was broken if he could not -- but I disagree with him.

But since I wanted this tree to be uncontentious and obviously the
correct thing to do, I've dropped the drivers/net changes for now
anyway.

It's odd that this request has suddenly come out of the blue when we've
been using request_firmware() from modules for years already.

> there was also the issue that was raised about how to handle firmware 
> during suspend/resume. I don't remember seeing a happy solution to that 
> one.

My b43 seems to work fine on suspend/resume, as do most other modern
drivers which use request_firmware(). There is certainly no fundamental,
generic problem with suspend/resume vs. the firmware loader.

If you see a problem with a specific driver which we've converted, do
please point it out.

-- 
dwmw2

