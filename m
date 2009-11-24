Return-Path: <linux-kernel-owner+w=401wt.eu-S933390AbZKXUrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390AbZKXUrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933150AbZKXUrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:47:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45813 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933027AbZKXUrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:47:51 -0500
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] "fair" rw spinlocks
From: Andi Kleen <andi@firstfloor.org>
References: <20091123145409.GA29627@wotan.suse.de>
Date: Tue, 24 Nov 2009 21:47:56 +0100
In-Reply-To: <20091123145409.GA29627@wotan.suse.de> (Nick Piggin's message of "Mon, 23 Nov 2009 15:54:09 +0100")
Message-ID: <87einnwsxv.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:

> Hi,
>
> Last time this issue came up that I could see, I don't think
> there were objections to making rwlocks fair, the main
> difficulty seemed to be that we allow reentrant read locks
> (so a write lock waiting must not block arbitrary read lockers).
>
> Nowadays our rwlock usage is smaller although still quite a
> few, so it would make better sense to do a conversion by
> introducing a new lock type and move them over I guess.

You want to do a new lock type for potentially nested rwlocks?

>From the basic idea it sounds good, but according
to grep the current tree has hundreds of rwlocks all over,
and how would you reliably detect whether they are nestable
or not?

I assume it's not something that could be easily analyzed
at compile time and relying on runtime would seem dangerous.

Basically it sounds like quite a lot of work.

A better plan might be to have new types which are non nestable
and only move over audited code to fair rwlocks.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
