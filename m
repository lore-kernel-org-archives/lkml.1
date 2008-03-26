Return-Path: <linux-kernel-owner+w=401wt.eu-S1760177AbYCZQbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177AbYCZQbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758733AbYCZQaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:30:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756889AbYCZQav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:30:51 -0400
Date: Wed, 26 Mar 2008 09:29:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Alan Mayer <ajm@sgi.com>, mingo@elte.hu,
       linux-kernel list <linux-kernel@vger.kernel.org>,
       Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH] x86_64: resize NR_IRQS for large machines
In-Reply-To: <20080325231034.GA3894@ucw.cz>
Message-ID: <alpine.LFD.1.00.0803260920020.2775@woody.linux-foundation.org>
References: <Pine.SGI.3.96.1080324092858.7873204S-100000@fergus.americas.sgi.com> <20080325231034.GA3894@ucw.cz>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 26 Mar 2008, Pavel Machek wrote:
> 
> This is very ugly. Why not include it unconditionally -- with guard in
> apicdef.h?

I do agree that it's ugly, but I think the ugliness is more serious than 
that.

What I think we should do is to make NR_IRQS no longer be a compile-time 
constant, but instead just do something like

	unsigned int NR_IRQS __read_mostly;

and then just set it early in the boot sequence depending on the real CPU 
numbers etc.

I realize that this will require some changes to a few arrays that are 
statically allocated and depend on NR_IRQ's (notably "irq_desc"), but 
don't you guys think that this would be a cleaner thing?

[ I suspect that irq_desc[] itself could quite reasonably be a rather much 
  smaller __read_mostly hash-table of dynamically allocated entries - the 
  thing would be only modified at boot, so it should cache beautifully 
  even across hundreds of CPU's ]

Whatever. I'm not opposed to this whole static thing, but I do wonder if 
it's worth doing that way. There *may* be performance reasons for doing it 
the way we're doing it, but quite frankly, I think the #define is mostly 
purely historical, from when it was just a fixed number (originally 16!) 
and it made sense to think of it as a small static array.

			Linus
