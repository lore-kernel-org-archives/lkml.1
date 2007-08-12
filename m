Return-Path: <linux-kernel-owner+w=401wt.eu-S934171AbXHLLYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934171AbXHLLYt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 07:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759894AbXHLLYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 07:24:40 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52659 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbXHLLYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 07:24:38 -0400
Date: Sun, 12 Aug 2007 13:24:37 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Al Boldi <a1426z@gawab.com>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] FUSE: mnotify (was: [RFC] VFS: mnotify)
In-Reply-To: <200708120632.20777.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.64.0708121322140.28963@fbirervta.pbzchgretzou.qr>
References: <200708120632.20777.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 12 2007 06:32, Al Boldi wrote:
>Al Boldi wrote:
>> Jakob Oestergaard wrote:
>> > Why on earth would you cripple the kernel defaults for ext3 (which is a
>> > fine FS for boot/root filesystems), when the *fundamental* problem you
>> > really want to solve lie much deeper in the implementation of the
>> > filesystem?  Noatime doesn't solve the problem, it just makes it "less
>> > horrible".
>>
>> inotify could easily solve the atime problem, but it's got the drawback of
>> forcing the user to register each and every file/dir of interest, which
>> isn't really reasonable on TB-filesystems.

What inotify needs is some kind of SUBDIR flag on a watch so that one does not
run out of fds, then the TB issue becomes a bit lighter I think.

>> It could be feasible to introduce mnotify, which would notify the user of
>> meta changes, like atime, across the filesystem.  Something like mnotify
>> could also be helpful in CoW situations, provided it supported an in-sync
>> interface.
>
>Here is an idea:  Could FUSE be used to produce mnotify behaviour?

It may, and in some cases, not. For example, I only had a single filesystem,
and would like atime notificatios for it, then how would I do that? What comes
to mind is to use a fuse fs that mirrors, but also notifies, ergo:
	mount -t fuse.lomount / /mnt
Well, wonderful, now I still need to pivot_root to /mnt, so that all accesses
actually end up in fuse-land. And this gets ugly on shutdown, when things have
to be unmounted.


	Jan
-- 
