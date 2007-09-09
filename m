Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbXIIWnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbXIIWnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 18:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbXIIWnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 18:43:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45058 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbXIIWnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 18:43:09 -0400
Date: Sun, 9 Sep 2007 23:41:18 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, perex@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-ID: <20070909234118.43d75f6f@laptopd505.fenrus.org>
In-Reply-To: <20070909222202.GB3563@stusta.de>
References: <20070909202527.GT3563@stusta.de>
	<20070909203920.GA11764@infradead.org>
	<20070909145940.0b41c8a5.akpm@linux-foundation.org>
	<20070909222202.GB3563@stusta.de>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 00:22:03 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> On Sun, Sep 09, 2007 at 02:59:40PM -0700, Andrew Morton wrote:
> > On Sun, 9 Sep 2007 21:39:20 +0100 Christoph Hellwig
> > <hch@infradead.org> wrote:

> > Adrian knows this, yet he habitually sends zero-warning
> > export-removal patches and I habitually ignore them.  I guess we
> > must both enjoy this or something.
> 
> You might rename EXPORT_UNUSED_SYMBOL to EXPORT_UNUSED_SYMBOL_ADRIAN 
> because AFAIK I am still the only person who was ever dumb enough to
> use it after you wanted me to do so...
> 
> Everyone else is allowed to always add, remove and change exports
> as he likes, but I should go through this special process.
> 
> It makes no sense (except for keeping me busy) to treat some patches
> I send special while changes made by other people that break the
> modules API are still allowed.
> 
> Andrew, please define API rules, IOW rules for addition, removal and 
> changing of exported code, that are valid for *everyone* or go to
> hell with your EXPORT_UNUSED_SYMBOL.


Adrian,

as much as I personally disagree with Andrew's policy here (esp for
these symbols, they have been deprecated for years now), it's trivial
to just follow his requirements and get this over with.

As for who cares.. I do care still, unused exports make the kernel
bigger for everyone, and for the most cases, encourage incorrect APIs
to be used by driver writers (they act as a trap; the symbols generally
are not used by anything in the kernel because they're the wrong API to
use for drivers; having them exported wrongly suggests to new driver
writers that they are good things to use). I plan to do another run of
finding all unused exports and just marking the lot as _UNUSED  exports.
(that's not the same as removing them quite yet, but at least it's a
good warning for driver writers that they should think twice about the
API to see if it's the right one to use)


Greetings,
    Arjan van de Ven
