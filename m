Return-Path: <linux-kernel-owner+w=401wt.eu-S1759522AbXJXVev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbXJXVev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbXJXVem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:34:42 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36255 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbXJXVem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:34:42 -0400
Date: Wed, 24 Oct 2007 15:34:41 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Stringbuf, v2
Message-ID: <20071024213440.GH27248@parisc-linux.org>
References: <20071024195847.GE27248@parisc-linux.org> <1193259097.19617.18.camel@localhost> <20071024205701.GF27248@parisc-linux.org> <1193259993.19617.23.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193259993.19617.23.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 02:06:33PM -0700, Joe Perches wrote:
> On Wed, 2007-10-24 at 14:57 -0600, Matthew Wilcox wrote:
> > If you look at the patches, you'll see that they basically all have a
> > wrapper around sb_printf that I was able to insert the GFP argument
> > into, so I don't see this as a win.
> 
> I was hoping that each module/subsystem would not need a
> separate wrapper and could use the plain sb_printf function.

Then they should carefully think about whether they need GFP_ATOMIC or
GFP_KERNEL.  Just like we don't have a kalloc() that uses GFP_ATOMIC
to spare people from having to think about it.

ISDN and sound had done that thinking for me -- one knew they needed
GFP_ATOMIC, the other needed GFP_KERNEL.  I was able to work out that
GFP_KERNEL made sense for the partition code.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
