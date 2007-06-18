Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbXFRIvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbXFRIvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 04:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbXFRIvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 04:51:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34503 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbXFRIvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 04:51:31 -0400
Subject: Re: [patch] use __asm__ and __volatile__ in i386/arm/s390
	byteorder.h
From: David Woodhouse <dwmw2@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arjan van de Ven <arjan@infradead.org>, Mike Frysinger <vapier@gentoo.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, rmk@arm.linux.org.uk
In-Reply-To: <200706180124.25574.arnd@arndb.de>
References: <200706171833.29046.vapier@gentoo.org>
	 <1182120674.22999.4.camel@laptopd505.fenrus.org>
	 <200706180124.25574.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 18 Jun 2007 16:51:45 +0800
Message-Id: <1182156706.2799.62.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-18 at 01:24 +0200, Arnd Bergmann wrote:
> On Monday 18 June 2007, Arjan van de Ven wrote:
> > 
> > On Sun, 2007-06-17 at 18:33 -0400, Mike Frysinger wrote:
> > > This changes asm() to __asm__() and volatile to __volatile__ so that these
> > > headers can be used with gcc's -std=c99.
> > 
> > hmm but the kernel doesn't use -std=c99...
> 
> The byteorder headers are exported to user space through
> include/asm-generic/Kbuild.asm, and they are used by a number
> of other exported headers, so they should work with any
> gcc flags that a user might want to use. 

Even those headers which are exported are _still_ kernel headers¹. The
'caveat emptor' principle still applies to them, and we don't have to be
_that_ anal about it. GNU extensions (and proper C types, for that
matter) should be acceptable, surely?

-- 
dwmw2

¹ well, except perhaps for the very few headers which get included 
  directly by glibc's headers, but aren't we still pretending that
  doesn't happen?


