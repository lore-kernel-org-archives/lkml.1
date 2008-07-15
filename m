Return-Path: <linux-kernel-owner+w=401wt.eu-S1761561AbYGOCy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbYGOCy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbYGOCyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:54:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40793 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbYGOCyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:54:50 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, david@lang.hm, arjan@infradead.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080714.185012.245476473.davem@davemloft.net>
References: <20080714165956.7fe2d4ee@infradead.org>
	 <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm>
	 <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org>
	 <20080714.185012.245476473.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 19:54:38 -0700
Message-Id: <1216090479.27455.180.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 18:50 -0700, David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Mon, 14 Jul 2008 17:33:58 -0700 (PDT)
> 
> > The only reliable way to handle it is to load the firmware before the 
> > suspend happens - preferably by simply never unloading it in the first 
> > place.
> 
> That's what we were told was the huge benefit of moving some
> of these drivers over to this request_firmware() stuff, it would
> save memory.

There _are_ RAM benefits for a number of drivers, even when you load the
firmware just once at initialisation time and keep it resident all the
time the device is active (and no, I won't slap myself for saying it).

The tg3 driver is a prime example -- it contains three separate firmware
images for different revisions of the card, but you'll almost never
actually need all three. Mostly you'll only need _one_ of them.

-- 
dwmw2

