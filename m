Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbZEZUcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbZEZUcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbZEZUcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:32:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755159AbZEZUcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:32:35 -0400
Date: Tue, 26 May 2009 13:30:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: vapier@gentoo.org, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] drivers/char/rtc: disable legacy RTC driver on Blackfin
 systems
Message-Id: <20090526133053.803c2ab8.akpm@linux-foundation.org>
In-Reply-To: <20090526102502.GA24737@infradead.org>
References: <1243332633-15258-1-git-send-email-vapier@gentoo.org>
	<20090526102502.GA24737@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 06:25:02 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, May 26, 2009 at 06:10:33AM -0400, Mike Frysinger wrote:
> >  	tristate "Enhanced Real Time Clock Support (legacy PC RTC driver)"
> >  	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV \
> > -			&& !ARM && !SUPERH && !S390 && !AVR32
> > +			&& !ARM && !SUPERH && !S390 && !AVR32 && !BLACKFIN
> 
> Maybe it's better to have a positive dependency for those that actually
> support it these days?

yeah, we do this rather a lot and it's pretty stupid.

>  Based on the above list that would be:
> 
> 	depends on ALPHA || CRIS || H8300 || M32R || MICROBLAZE ||
> 		   MIPS || MN10300 || SH || X86 || XTENSA
> 
> and I would not be surprised if some of the above don't actually support
> it either..

It would be better to make this driver depend on simply CONFIG_WANT_RTC
or similar and then select CONFIG_WANT_RTC in the relevant
arch/foo/Kconfig files.

