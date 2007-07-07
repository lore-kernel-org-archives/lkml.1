Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbXGGXkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbXGGXkB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 19:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbXGGXjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 19:39:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34070 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752059AbXGGXjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 19:39:52 -0400
Date: Sat, 7 Jul 2007 16:38:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@stusta.de>,
       Patrick Caulfield <pcaulfie@redhat.com>,
       David Teigland <teigland@redhat.com>, bluez-devel@lists.sourceforge.net,
       Marcel Holtmann <marcel@holtmann.org>, Jiri Kosina <jkosina@suse.cz>,
       Dmitry Torokhov <dtor@insightbb.com>
Subject: Re: 2.6.22-rc7: known regressions with patches v2
In-Reply-To: <Pine.LNX.4.64.0707071557160.16503@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.0.999.0707071633320.31544@woody.linux-foundation.org>
References: <468FBA20.8060509@googlemail.com>  <1183825391.3066.59.camel@shinybook.infradead.org>
 <6bffcb0e0707070959m12ba9b66n8587605eb1f6c21e@mail.gmail.com>
 <Pine.LNX.4.64.0707071557160.16503@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 7 Jul 2007, Christoph Lameter wrote:
> 
> What are these functions "malloc" and "free"? Would be good if those 
> would be using kmalloc_track_caller() so that we can figure out who called 
> them.

There's not a lot of those around. Looks like it's probably one of

	init/do_mounts_rd.c:static void __init *malloc(size_t size)
	init/initramfs.c:static void __init *malloc(size_t size)

both of which exist just because those things include "lib/inflate.c".

It's probably do_mounts_rd.c, because initramfs.c defines malloc/free 
before the #include, and I would have expected gcc to just inline them in 
that case.

That's probably the right thign to do in do_mounts_rd.c too, rather than 
adding any kmalloc_track_caller() stuff.

		Linus
