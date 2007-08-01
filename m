Return-Path: <linux-kernel-owner+w=401wt.eu-S1765396AbXHANe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765396AbXHANe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 09:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762592AbXHANeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 09:34:07 -0400
Received: from mail.suse.de ([195.135.220.2]:45909 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763519AbXHANeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 09:34:05 -0400
Date: Wed, 1 Aug 2007 15:33:58 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Dan Merillat <dan.merillat@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Matt Mackall <mpm@selenic.com>,
       Rene Herman <rene.herman@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Bodo Eggert <7eggert@gmx.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070801133358.GD6910@v2.random>
References: <20070719013955.1bedc423@the-village.bc.nu> <20070719013358.GD29728@v2.random> <20070719013725.GP11115@waste.org> <20070719112436.GG29728@v2.random> <20070719124419.48c3d610@the-village.bc.nu> <46A9ECD5.3050801@sandeen.net> <20070727183807.2d7dbe7b@the-village.bc.nu> <a781481a0707271131j3ab89470o4dea2fe2624fca32@mail.gmail.com> <46B003A3.1090507@sandeen.net> <a56dfcf00708010111n4b862a11wf91fe9677ee46143@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a56dfcf00708010111n4b862a11wf91fe9677ee46143@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 04:11:23AM -0400, Dan Merillat wrote:
> How expensive would it be to allocate two , then use the MMU mark the
> second page unwritable? Hardware wise it should be possible,  (for

Tweaking kernel ptes is prohibitive during clone() because that's
kernel memory and it would require a flush tlb all with IPIs that
won't scale (IPIs are really the blocker). Basically vmalloc already
does what you suggest with the gap page and yet we can't use it for
performance reasons. Kernel stack should be readable by any context to
allow sysrq+t kind of things, so I doubt it's feasible to do tricks to
avoid ipis.
