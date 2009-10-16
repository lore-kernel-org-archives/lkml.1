Return-Path: <linux-kernel-owner+w=401wt.eu-S1751937AbZJPE26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbZJPE26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 00:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZJPE24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 00:28:56 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:52945 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbZJPE2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 00:28:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=R0Jk1t+WfzgCXmJ3w//13DytIh1Ed7B0r8CyGYSSYHlpsk/+JLOMNO5aEtegYWdEdW
         QyQbo4zzs8ISOZyuojN18PminZ7qHAoT4eqnrUj0Cfu1ikEib81T7MYEODBHukqTP+q2
         LOm2kZHI3J3fZN8huG2tjAzvDZ7iDEvqRckls=
MIME-Version: 1.0
Date: Fri, 16 Oct 2009 00:28:18 -0400
Message-ID: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com>
Subject: ext4 increased intolerance to unclean shutdown?
From: Parag Warudkar <parag.lkml@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: tytso@mit.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I have been experimenting with various root file systems on my
laptop running latest git. This laptop some times has problems waking
up from sleep and that results in it needing a hard reset and
subsequently unclean file system.

Initially I had ext3 on and never really had any visible filesystem
issues for quite some time even with hard resets after wakeup. Then I
switched to ext4 and first time it failed to wakeup from sleep fsck
took me through quite a bit of errors - but after fixing them it
immediately went and hit EXT4-fs error and it was unusable there
onwards until (if I recall correctly) I found the file path associated
with the inode relating to that message and used debugfs to delete the
file only to have segfaults on subsequent boot. That was some time
ago.

Meanwhile I was running xfs root and had the laptop fail to wakeup a
fair number of times with no visible file system related issue.

This evening I needed to secure erase the abused SSD and that gave me
a chance to retry ext4. But as bad luck would have it, the laptop just
failed to wakeup and had to be reset. Sure enough, a ton of errors
needed to be fixed when fsck went through the ext4 root fs. I had
/boot as 8gb ext3 on same disk and that one showed no errors. But the
bad part was it still failed to boot to desktop (GDM could not write
to authorization file) after repairing the ext4 root fs. I forced
another fsck on the root fs and it (again) found another handful of
things to fix. So now it boots to desktop but some startup service
still fails to start or stop.

So what's going on? I understand all bets are off when you have to
hard reset - but based on my anecdotal experience it seems to me like
ext4 has grown more intolerant to unclean shutdowns. Is this to be
expected or it's just sheer coincidence?

Curious to understand the reason if any - don't care about the data
loss part, as I had purposefully not kept anything important on the
filesystems.

Thanks

Parag
