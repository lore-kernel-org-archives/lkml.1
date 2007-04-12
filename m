Return-Path: <linux-kernel-owner+w=401wt.eu-S1161148AbXDLJNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161148AbXDLJNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932212AbXDLJNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:13:50 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:39305 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932190AbXDLJNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:13:50 -0400
From: syrius.ml@no-log.org
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [dm-devel] bio too big device md1 (16 > 8)
Message-ID: <876482ezuq.874pnmezuq@873b36ezuq.message.id>
References: <87irc84bcq.87hcrs4bcq@87fy7c4bcq.message.id>
	<17948.8871.997123.363344@notabene.brown>
Date: Thu, 12 Apr 2007 11:13:48 +0200
In-Reply-To: <17948.8871.997123.363344@notabene.brown> (Neil Brown's message
	of "Wed, 11 Apr 2007 09:49:59 +1000")
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown <neilb@suse.de> writes:

> This is difficult.
>
> Summary of problem is:
>   Filesystem on LVM on md/raid1
>   Add an md/linear to the md/raid1 and fs dies with 'bio too big'.
>
> [...]
>
> You can probably make your array work by adding the md/linear array to
> the md/raid1 *before* enabling the LVM device on top of it.  However
> that isn't really a good long-term solution.

Thanks for the explanations !
That's the kind of solution i did use. But it seems I achieved to add
the md/linear array to the md/raid1 after lvm was enabled, I only have
to not to use an initrd.

the kernel I'm using at the moment is a 2.6.18-4-vserver-xen (debian
one) plus the following patches:
- dm-io-fix-bi_max_vecs.patch
- dm-merge-max_hw_sector.patch
also i'm using #define RESYNC_BLOCK_SIZE PAGE_SIZE rather than
(64*1024) in raid1.c.

Not sure if that could explain the fact i was able to add the md/linear
array to the md/raid1 after enabling lvm. (still i had not to use an
initrd)

When I have more time I'll try to reproduce this on a test machine.

> We really need better ways for stacked devices to communicate.
>
> Alasdair Kergon (dm developer) has some patches to make it practical
> to recursively call merge_bvec_fn so they might be part of the
> solution, but more discussion is needed before that becomes a reality.

Ok, i'd be curious to test them (if they're usable and publicly
available)

> Sorry I cannot be more helpful at this stage.

Thanks. (at least i understand(-ish) what's going on) ;-)

-- 
