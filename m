Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbXJXU5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbXJXU5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 16:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbXJXU5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 16:57:05 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:43407 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbXJXU5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 16:57:02 -0400
Date: Wed, 24 Oct 2007 14:57:01 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Stringbuf, v2
Message-ID: <20071024205701.GF27248@parisc-linux.org>
References: <20071024195847.GE27248@parisc-linux.org> <1193259097.19617.18.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193259097.19617.18.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 01:51:37PM -0700, Joe Perches wrote:
> On Wed, 2007-10-24 at 13:58 -0600, Matthew Wilcox wrote:
> >  - Pass a gfp_t to sb_printk
> 
> sb_printf

indeed.

> As it doesn't actually output anything but extends
> a buffer pointer in a struct, perhaps it's better to
> rename sb_printf to sb_sprintf.

printf prints to stdout.  fprintf prints to a file.  sprintf prints to
a string.  sb_printf prints to an sb.

> I believe the common use will be GFP_ATOMIC.

An interesting belief.  Of the three users I've converted, one uses
GFP_ATOMIC and two use GFP_KERNEL.

> Perhaps a default wrapper define and a renamed function?
> 
> void sb_sprintf_gfp(struct stringbuf *sb, gfp_t gfp, const char *fmt, ...)
> 
> #define sb_sprintf(sb, fmt, arg...) \
> 	sb_sprintf_gfp(sb, GFP_ATOMIC, fmt, ##arg)

If you look at the patches, you'll see that they basically all have a
wrapper around sb_printf that I was able to insert the GFP argument
into, so I don't see this as a win.  I hadn't bothered with one for
ISDN, and that one involved much more editing.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
