Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbXJXUwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbXJXUwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 16:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbXJXUv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 16:51:56 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3636 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbXJXUvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 16:51:55 -0400
Subject: Re: Stringbuf, v2
From: Joe Perches <joe@perches.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071024195847.GE27248@parisc-linux.org>
References: <20071024195847.GE27248@parisc-linux.org>
Content-Type: text/plain
Date: Wed, 24 Oct 2007 13:51:37 -0700
Message-Id: <1193259097.19617.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-24 at 13:58 -0600, Matthew Wilcox wrote:
>  - Pass a gfp_t to sb_printk

sb_printf

As it doesn't actually output anything but extends
a buffer pointer in a struct, perhaps it's better to
rename sb_printf to sb_sprintf.

I believe the common use will be GFP_ATOMIC.
Perhaps a default wrapper define and a renamed function?

void sb_sprintf_gfp(struct stringbuf *sb, gfp_t gfp, const char *fmt, ...)

#define sb_sprintf(sb, fmt, arg...) \
	sb_sprintf_gfp(sb, GFP_ATOMIC, fmt, ##arg)

