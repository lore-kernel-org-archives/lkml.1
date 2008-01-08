Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbYAHQxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbYAHQxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757988AbYAHQxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:53:15 -0500
Received: from ns.suse.de ([195.135.220.2]:58702 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757964AbYAHQxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:53:14 -0500
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
From: Andi Kleen <andi@firstfloor.org>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
Date: Tue, 08 Jan 2008 17:53:13 +0100
In-Reply-To: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> (Tuomo Valkonen's message of "Tue\, 8 Jan 2008 16\:07\:27 +0000 \(UTC\)")
Message-ID: <p73odbwqmx2.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tuomo Valkonen <tuomov@iki.fi> writes:

> The ext3 journalling code can be summarised as:
>
>     superblock->last_checked = random();
>     sync(superblock)
>
> I hate it: every time Linux crashes, e.g. due to power failure, it takes
> almost an hour to boot,

tune2fs -i0 -c0 device      for each file system

Yes that should be default, unfortunately it is not. It's one 
of the first things I do on new machines.

> Thank you very much. The disk worked perfectly well without that "fix"

fsck is actually seek bound, most likely it won't make much difference
for fsck. Seeky disk IO is always slow on a spinning disk.

There's actually been a patchkit recently to make fsck much faster
by clustering metadata better so it can be reached with less seeks,
but that hasn't reached mainline yet and and will unfortunately
require freshly created file systems.

-Andi
