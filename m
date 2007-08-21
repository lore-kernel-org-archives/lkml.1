Return-Path: <linux-kernel-owner+w=401wt.eu-S1760813AbXHUO4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760813AbXHUO4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 10:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758846AbXHUO4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 10:56:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36232 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758639AbXHUO4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 10:56:09 -0400
Subject: Re: uncached page allocator
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       dri-devel <dri-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
In-Reply-To: <21d7e9970708202305h5128aa5cy847dafe033b00742@mail.gmail.com>
References: <21d7e9970708191745h3b579f3bp72f138e089c624da@mail.gmail.com>
	 <20070820094125.209e0811@the-village.bc.nu>
	 <21d7e9970708202305h5128aa5cy847dafe033b00742@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 21 Aug 2007 16:56:05 +0200
Message-Id: <1187708165.6114.256.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-21 at 16:05 +1000, Dave Airlie wrote:

> So you can see why some sort of uncached+writecombined page cache
> would be useful, I could just allocate a bunch of pages at startup as
> uncached+writecombined, and allocate pixmaps from them and when I
> bind/free the pixmap I don't need the flush at all, now I'd really
> like this to be part of the VM so that under memory pressure it can
> just take the pages I've got in my cache back and after flushing turn
> them back into cached pages, the other option is for the DRM to do
> this on its own and penalise the whole system.

Can't you make these pages part of the regular VM by sticking them all
into an address_space.

And for this reclaim behaviour you'd only need to set PG_private and
have a_ops->releasepage() dtrt.



