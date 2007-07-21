Return-Path: <linux-kernel-owner+w=401wt.eu-S933598AbXGUMo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598AbXGUMo3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 08:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762340AbXGUMoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 08:44:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60110 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762811AbXGUMoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 08:44:20 -0400
Date: Sat, 21 Jul 2007 13:44:18 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sebastian Siewior <sebastian@breakpoint.cc>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] compat_ioctl requires CONFIG_BLOCK
Message-ID: <20070721124418.GA23802@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sebastian Siewior <sebastian@breakpoint.cc>,
	linux-kernel@vger.kernel.org
References: <20070720225817.050195257@ayoka.breakpoint.cc> <200707210108.58478.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707210108.58478.arnd@arndb.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 01:08:57AM +0200, Arnd Bergmann wrote:
> On Saturday 21 July 2007, Sebastian Siewior wrote:
> > 
> > Got with randconfig
> > include/linux/loop.h:66: error: expected specifier-qualifier-list before
> > 'request_queue_t'
> > make[1]: *** [fs/compat_ioctl.o] Error 1
> > 
> > parts of compat ioctl require CONFIG_BLOCK to be set.
> > 
> > Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
> > Index: b/fs/compat_ioctl.c
> > ===================================================================
> > --- a/fs/compat_ioctl.c
> > +++ b/fs/compat_ioctl.c
> > @@ -63,7 +63,9 @@
> > ?#include <linux/wireless.h>
> > ?#include <linux/atalk.h>
> > ?#include <linux/blktrace_api.h>
> > +#ifdef CONFIG_BLOCK
> > ?#include <linux/loop.h>
> > +#endif
> 
> Adding #ifdef around an #include is considered bad style. Better just
> make loop.h compile without any conditionals. Does the below
> patch work for you?

That patch looks good, but even better would be adding a compat_ioctl
handler to the loop driver.  IIRC you even have an old patch for that :)

