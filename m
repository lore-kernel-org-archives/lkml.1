Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbZHJWwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbZHJWwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 18:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZHJWwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 18:52:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46640 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847AbZHJWwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 18:52:11 -0400
Message-ID: <4A80A37C.9000808@redhat.com>
Date: Mon, 10 Aug 2009 12:47:24 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090317)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       axboe@kernel.dk, hch@infradead.org, akpm@linux-foundation.org,
       Paul.Clements@steeleye.com, tytso@mit.edu
Subject: Re: [PATCH] Allow userspace block device implementation
References: <4A6D79F6.3050509@redhat.com> <20090807180841.GC1728@ucw.cz>
In-Reply-To: <20090807180841.GC1728@ucw.cz>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!

Hey!

> And yes, I believe that's show stopper. OTOH if you _can_ solve
> that... then you have some rather significant advantage over nbd.
> 
> (But guaranteeing progress for dirty writeout will be tricky even with
> mlocked userland, AFAICT...)

Actually, impossible, even with mlocked userland (*) which is what led
me to abandon going any further with it.  The problem is, to commit any
data, one must make a system call, thus consuming more resources.  It's
merely a toy, nothing more.  Sometimes it might be a useful toy, as nbd,
but nbd, being in kernel, has at least a better chance of solving the
swap problem.

(*) strictly speaking, it is possible to guarantee progress of the
device for read/write only to a finite region of mlocked memory and an
infinite region (limited only by size of off_t) of read-only data
computable with finite mlocked space.  Obviously, neither of these
(swap-to-ram), and (swap-over-ro-media) are actually useful for swap.

Zach
