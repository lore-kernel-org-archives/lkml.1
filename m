Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646Ab0ABNl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0ABNl6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 08:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593Ab0ABNl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 08:41:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56382 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab0ABNl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 08:41:56 -0500
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] reiserfs fixes
From: Andi Kleen <andi@firstfloor.org>
References: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com>
Date: Sat, 02 Jan 2010 14:41:51 +0100
In-Reply-To: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com> (Frederic Weisbecker's message of "Sat,  2 Jan 2010 02:27:16 +0100")
Message-ID: <87bphc7heo.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:
>
> That's why you'll mostly find dependency inversion fixes based on
> such pattern:
>
> reiserfs_write_unlock()
> mutex_lock(random_lock)
> reiserfs_write_lock()

These `workarounds' look rather ugly and are likely much slower
than the BKL that was there before. Perhaps it's better to simply
go back to the BKL until this can be all fixed properly
(or a more faithful emulation for the BKL can be devised)?

>
> This is not beautiful but at least that's better than the bkl.
>
> Oh and I expect other lock inversions will get reported in
> the future due to rare and then yet untested paths.

... and given that was the conversion really a good idea?

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
