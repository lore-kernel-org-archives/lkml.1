Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbYHTSrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbYHTSrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 14:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbYHTSri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 14:47:38 -0400
Received: from gw.goop.org ([64.81.55.164]:35765 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbYHTSrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 14:47:37 -0400
Message-ID: <48AC66C6.1080406@goop.org>
Date: Wed, 20 Aug 2008 11:47:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jaya Kumar <jayakumar.lkml@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Ian Campbell <ijc@hellion.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh@veritas.com>, Johannes Weiner <hannes@saeurebad.de>,
       Kel Modderman <kel@otaku42.de>, Markus Armbruster <armbru@redhat.com>
Subject: Re: [PATCH] fbdefio: add set_page_dirty handler to deferred IO FB
References: <1219125765-31833-1-git-send-email-ijc@hellion.org.uk>	 <20080818233824.5d219105.akpm@linux-foundation.org> <45a44e480808200146m1167b8e6o74d68324ad138dc5@mail.gmail.com>
In-Reply-To: <45a44e480808200146m1167b8e6o74d68324ad138dc5@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaya Kumar wrote:
> I hope I have understood your question. You are right that PG_dirty
> isn't used directly in defio. The defio portion does use each
> page_mkwrite callback to build a list of the pages of the framebuffer
> that were written to and then passes that list to pvfb (in this case).
> pvfb then optimizes writeback by interpreting that list according to
> its framebuffer and sending it to its actual destination. I think
> Markus's code in xenfb_deferred_io() and xenfb_send* is doing the
> latter.
>   

The original Xen-specific implementation of this did use PG_dirty, which
has the nice property of using the hardware feature without invoking any
pagefaults.  It would be nice if defio could be extended to allow this
on platforms where it makes sense.

    J
