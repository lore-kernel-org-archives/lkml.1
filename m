Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbZJLRhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbZJLRhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757408AbZJLRhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:37:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51796 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337AbZJLRhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:37:16 -0400
To: Bernhard Walle <bernhard@bwalle.de>
Cc: akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH 5/5] Always print panic message on current console
From: Andi Kleen <andi@firstfloor.org>
References: <1255207870-24496-1-git-send-email-bernhard@bwalle.de>
	<1255207870-24496-6-git-send-email-bernhard@bwalle.de>
Date: Mon, 12 Oct 2009 19:36:36 +0200
In-Reply-To: <1255207870-24496-6-git-send-email-bernhard@bwalle.de> (Bernhard Walle's message of "Sat, 10 Oct 2009 22:51:10 +0200")
Message-ID: <87d44sh5uj.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle <bernhard@bwalle.de> writes:

> The kernel offers with TIOCL_GETKMSGREDIRECT ioctl() the possibility to
> redirect the kernel messages to a specific console.
>
> However, since it's not possible to switch to the kernel message console after
> a panic(), it would be nice if the kernel would print the panic message on the
> current console.

The basic idea is good, but you really need to call this in a lot
more places, which print some addition needed information before the panic.
The one liner panic is often not enough to decide what went wrong.
Example are machine checks, oopses, probably more.

In general for the recent work to switch the video mode on panic
we need a generalized hook for this anyways, so you could use
some generalized function.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
