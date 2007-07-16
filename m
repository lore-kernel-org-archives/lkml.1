Return-Path: <linux-kernel-owner+w=401wt.eu-S1764771AbXGPWDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764771AbXGPWDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760848AbXGPWDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:03:38 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:49923 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756789AbXGPWDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:03:37 -0400
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Arnd Bergmann <arnd@arndb.de>,
       linux-scsi@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Alessandro Rubini <rubini@vision.unipv.it>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <1184622555.25235.91.camel@localhost.localdomain>
References: <20070704132212.726923000@pademelon.sonytel.be>
	 <Pine.LNX.4.62.0707131541150.18802@pademelon.sonytel.be>
	 <1184335333.3402.20.camel@localhost.localdomain>
	 <200707131619.54898.arnd@arndb.de>
	 <Pine.LNX.4.62.0707131707290.18802@pademelon.sonytel.be>
	 <1184340528.3402.32.camel@localhost.localdomain>
	 <Pine.LNX.4.62.0707132212520.23000@chinchilla.sonytel.be>
	 <Pine.LNX.4.62.0707161338230.1072@pademelon.sonytel.be>
	 <20070716121649.GI5195@kernel.dk>
	 <1184593643.3447.9.camel@localhost.localdomain>
	 <1184622555.25235.91.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 16 Jul 2007 17:03:34 -0500
Message-Id: <1184623415.3447.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-17 at 07:49 +1000, Benjamin Herrenschmidt wrote:
> > No ... that was the point of flush_kernel_dcache_page().  The page in
> > question is page cache backed and contains user mappings.  However, the
> > block layer has already done a flush_dcache_page() in get_user_pages()
> > and the user shouldn't be touching memory under I/O (unless they want
> > self induced aliasing problems) so we're free to assume all the user
> > cachelines are purged, hence all we have to do is flush the kernel alias
> > to bring the page up to date and make the users see it correctly.
> 
> The block layer will have done that even in the swap-out path ? (Just
> asking... I'm not very familiar with the block layer)

Er ... not really, this is the I/O path for user initiated I/O.  The
page out path, by definition, can't have any extant user mappings.  For
page out, the relevant page is flushed before its mapping is detached,
and then it can be paged to the backing store (or for anonymous pages to
the swap device) when no mappings remain.

James


