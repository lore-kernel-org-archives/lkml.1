Return-Path: <linux-kernel-owner+w=401wt.eu-S1764067AbXGPVlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764067AbXGPVlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbXGPVk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:40:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:56380 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759514AbXGPVk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:40:57 -0400
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Arnd Bergmann <arnd@arndb.de>,
       linux-scsi@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Alessandro Rubini <rubini@vision.unipv.it>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <1184593643.3447.9.camel@localhost.localdomain>
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
Content-Type: text/plain
Date: Tue, 17 Jul 2007 07:40:19 +1000
Message-Id: <1184622019.25235.81.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-16 at 08:47 -0500, James Bottomley wrote:
> 
> No ... that was the point of flush_kernel_dcache_page().  The page in
> question is page cache backed and contains user mappings.  However,
> the
> block layer has already done a flush_dcache_page() in get_user_pages()
> and the user shouldn't be touching memory under I/O (unless they want
> self induced aliasing problems) so we're free to assume all the user
> cachelines are purged, hence all we have to do is flush the kernel
> alias
> to bring the page up to date and make the users see it correctly. 

Ok. In our case the problem is not aliases though, it's the coherency
between instruction and data caches for pages that may be executed from
(such as swapped out text pages).

Ben.


