Return-Path: <linux-kernel-owner+w=401wt.eu-S935176AbXK3PGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935176AbXK3PGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 10:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933645AbXK3PGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 10:06:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58644 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933444AbXK3PGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 10:06:40 -0500
Subject: Re: [PATCH 9/9] MN10300: Fix MTD JEDEC probe so that the ASB2303
	bootprom can be detected [2.6.24-rc3-mm2]
From: David Woodhouse <dwmw2@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: thayne@plug.org, akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <28258.1196431276@redhat.com>
References: <1196430400.13978.26.camel@pmac.infradead.org>
	 <20071129225219.21536.58653.stgit@warthog.procyon.org.uk>
	 <20071129225301.21536.91506.stgit@warthog.procyon.org.uk>
	 <28258.1196431276@redhat.com>
Content-Type: text/plain
Date: Fri, 30 Nov 2007 15:06:33 +0000
Message-Id: <1196435193.13978.35.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-11-30 at 14:01 +0000, David Howells wrote:
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > I don't like this -- it shouldn't be necessary.
> 
> Actually, I think you're right.  I think the problem is that:
> 
>         if (uaddr != MTD_UADDR_NOT_SUPPORTED ) {
>                 /* ASSERT("The unlock addresses for non-8-bit mode
>                    are bollocks. We don't really need an array."); */
>                 uaddr = finfo->uaddr[0];
>         }
> 
> Should be:
> 
>         if (uaddr == MTD_UADDR_NOT_SUPPORTED ) {
>                 /* ASSERT("The unlock addresses for non-8-bit mode
>                    are bollocks. We don't really need an array."); */
>                 uaddr = finfo->uaddr[0];
>         }

Nah, it does what it's supposed to. Really, the only information in the
uaddr[] array is the information about what widths are supported, and
the _first_ unlock address is the only one we should care about.

It should change to a bitmask for the widths which are supported, and a
single int for the uaddr.

> Otherwise the finfo->uaddr[] table is useless because only the first row will
> be used, except for unsupported configurations where uaddr will be set to
> MTD_UADDR_NOT_SUPPORTED.

That is basically the assertion being made, yes. And it's true -- which
is why I didn't want you removing it ;)

> With the ASB2303 bootprom I need to use the second row because it's in the x16
> configuration, *not* the x8.

No, you need to use the second row because the first row is incorrect.
It ought to contain what's in the second row. :)

-- 
dwmw2

