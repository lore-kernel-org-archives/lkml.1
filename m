Return-Path: <linux-kernel-owner+w=401wt.eu-S932688AbXHAPrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688AbXHAPrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbXHAPrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:47:37 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39037 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764007AbXHAPrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:47:35 -0400
Date: Wed, 1 Aug 2007 16:44:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrea Arcangeli <andrea@suse.de>
Cc: Dan Merillat <dan.merillat@gmail.com>, Eric Sandeen <sandeen@sandeen.net>,
       Satyam Sharma <satyam.sharma@gmail.com>, Matt Mackall <mpm@selenic.com>,
       Rene Herman <rene.herman@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Bodo Eggert <7eggert@gmx.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070801164408.1d5ed1c1@the-village.bc.nu>
In-Reply-To: <20070801133358.GD6910@v2.random>
References: <20070719013955.1bedc423@the-village.bc.nu>
	<20070719013358.GD29728@v2.random>
	<20070719013725.GP11115@waste.org>
	<20070719112436.GG29728@v2.random>
	<20070719124419.48c3d610@the-village.bc.nu>
	<46A9ECD5.3050801@sandeen.net>
	<20070727183807.2d7dbe7b@the-village.bc.nu>
	<a781481a0707271131j3ab89470o4dea2fe2624fca32@mail.gmail.com>
	<46B003A3.1090507@sandeen.net>
	<a56dfcf00708010111n4b862a11wf91fe9677ee46143@mail.gmail.com>
	<20070801133358.GD6910@v2.random>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007 15:33:58 +0200
Andrea Arcangeli <andrea@suse.de> wrote:

> On Wed, Aug 01, 2007 at 04:11:23AM -0400, Dan Merillat wrote:
> > How expensive would it be to allocate two , then use the MMU mark the
> > second page unwritable? Hardware wise it should be possible,  (for
> 
> Tweaking kernel ptes is prohibitive during clone() because that's
> kernel memory and it would require a flush tlb all with IPIs that
> won't scale (IPIs are really the blocker)

Agreed - except when doing debug work then its an acceptable cost. You
still have to sort the debug side out because you are going to fault the
kernel stack which will probably then cause a triple fault and reboot on
the spot.
