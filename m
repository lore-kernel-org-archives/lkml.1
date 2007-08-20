Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbXHTT4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbXHTT4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 15:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbXHTT4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 15:56:11 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39520 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753912AbXHTT4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 15:56:10 -0400
Date: Mon, 20 Aug 2007 21:55:22 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Dike <jdike@addtoit.com>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH 1/6] UML - Fix inlines
Message-ID: <20070820195522.GG32595@stusta.de>
References: <20070817194340.GA8734@c2.user-mode-linux.org> <20070820124030.d603b928.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070820124030.d603b928.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 12:40:30PM -0700, Andrew Morton wrote:
> On Fri, 17 Aug 2007 15:43:40 -0400
> Jeff Dike <jdike@addtoit.com> wrote:
> 
> > "extern inline" will have different semantics with gcc 4.3.
> 
> What are these different semantics?

With gcc <= 4.2, when using "extern inline" in no case the function is
compiled on its own, not even if you refer to its address explicitly.  
Such an address becomes an external reference, as if you had only 
declared the function, and had not defined it.

In C99 (and therefore in gcc >= 4.3), "extern inline" means that the 
function should be compiled inline where the inline definition is seen, 
and that the compiler should also emit a copy of the function body with 
an externally visible symbol.

Except for the Alpha port all users in the kernel used "extern inline" 
only for getting "static inline" semantics (older gcc versions didn't 
offer the always_inline function attribute).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

