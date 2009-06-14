Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbZFNKy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbZFNKy0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 06:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbZFNKyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 06:54:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55472 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755216AbZFNKyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 06:54:19 -0400
Date: Sun, 14 Jun 2009 11:54:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: tty_ldisc_try_get(): BUG kmalloc-8: Poison overwritten
Message-ID: <20090614115428.1127ed2d@lxorguk.ukuu.org.uk>
In-Reply-To: <20090614081052.GA9276@elte.hu>
References: <20090614081052.GA9276@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009 10:10:52 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> Ok, this is one for those who like to look at weird crashes/bugs.
> 
> Here's a new regression that popped up in this merge window, there's 
> some sort of slab corruption going on in tty data structures:

I split the ldisc and tty apart and redid the ldisc locking so its a fair
bet I know what changeset is to blame, will just need to hunt it down a
bit. kmemcheck found one leak case on Friday which I've fixed but not yet
scribbles.

>  c65c9bc: tty: rewrite the ldisc locking

Almost certainly that one and will investigate on Monday

Alan
