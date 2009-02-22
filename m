Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbZBVWSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbZBVWSn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 17:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZBVWSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 17:18:35 -0500
Received: from thunk.org ([69.25.196.29]:52900 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbZBVWSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 17:18:34 -0500
Date: Sun, 22 Feb 2009 17:18:29 -0500
From: Theodore Tso <tytso@mit.edu>
To: Giangiacomo Mariotti <gg.mariotti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.28.7 - ext4 : possible circular locking dependency
	detected
Message-ID: <20090222221828.GH17066@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Giangiacomo Mariotti <gg.mariotti@gmail.com>,
	linux-kernel@vger.kernel.org
References: <12bfabe40902212114h271b3728tac48b8283d33c20b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12bfabe40902212114h271b3728tac48b8283d33c20b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 06:14:57AM +0100, Giangiacomo Mariotti wrote:
> Through dmesg I got this error message :
> 
> [10484.092587] =======================================================
> [10484.092593] [ INFO: possible circular locking dependency detected ]
> [10484.092597] 2.6.28.7-my001 #1
> [10484.092600] -------------------------------------------------------
> [10484.092604] kjournald2/3695 is trying to acquire lock:
> [10484.092608]  (&meta_group_info[i]->alloc_sem){----}, at:
> [<ffffffffa039b6d9>] ext4_mb_load_buddy+0xd9/0x34a [ext4]
> [10484.092633]
> [10484.092634] but task is already holding lock:
> [10484.092638]  (&journal->j_list_lock#2){--..}, at:
> [<ffffffffa0370033>] jbd2_journal_commit_transaction+0xf06/0x117b
> [jbd2]

This is fixed in mainline after 2.6.29-rc5, in commit ba4439.  Over
this past weekend I backported the most recent set of fixes for the
2.6.28.y and 2.6.27.y series.  I've asked interested people to test
the for-stable and for-stable-2.6.27 branches of the ext4 git tree; if
I don't get any breakage reports, I'll send this set of fixes to
stable@kernel.org in the next couple of days.

Regards,

						- Ted
