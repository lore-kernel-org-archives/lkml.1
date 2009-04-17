Return-Path: <linux-kernel-owner+w=401wt.eu-S1760436AbZDQSyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760436AbZDQSyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 14:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757826AbZDQSy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 14:54:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757431AbZDQSy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 14:54:27 -0400
Date: Fri, 17 Apr 2009 11:50:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: spock@gentoo.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] fbdev: fix fillrect for 24bpp modes
Message-Id: <20090417115048.0c5ca35d.akpm@linux-foundation.org>
In-Reply-To: <20090417183617.ed7553cd.krzysztof.h1@poczta.fm>
References: <20090413170954.GA8403@tria>
	<20090417183617.ed7553cd.krzysztof.h1@poczta.fm>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009 18:36:17 +0200
Krzysztof Helt <krzysztof.h1@poczta.fm> wrote:

> On Mon, 13 Apr 2009 19:09:54 +0200
> Michal Januszewski <spock@gentoo.org> wrote:
> 
> ...
>
> The r is simply dst_idx / bits. Most compilers will optimize it away into 
> a simple shift because the bits has only one bit set (it is number of bits in a long variable, ie. 32 or 64).
> 
> > +		pat = pat << ((left*r) % bpp) | pat >> ((right*r) % bpp);
> >  
> 
> If the r = (dst_idx / bits) it is number of long words. The shift by ((left*r) % bpp) does
> not make much sense (try left = 3 and r = 24 words - it is always zero but should be 3). 
> It is even worse if a line is padded so line's length modulo bpp is not 
> zero it does not work. A colorful pattern is produced  after the "mtest" text.
> 
> A dst_idx offset is not taken into account (it could be non-zero only for depths < 8 bits).
> 

OK, thanks for checking.

Michael, I'll await a version 2 on this patch.  It looks like something
we want in 2.6.30.

