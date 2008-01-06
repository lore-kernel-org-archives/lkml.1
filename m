Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbYAFN4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbYAFN4E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 08:56:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYAFNzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 08:55:53 -0500
Received: from www17.your-server.de ([213.133.104.17]:49633 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbYAFNzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 08:55:52 -0500
Message-ID: <4780DDBB.7090807@m3y3r.de>
Date: Sun, 06 Jan 2008 14:55:07 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071118)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, matthew@wil.cx,
       Ingo Molnar <mingo@elte.hu>, James.Bottomley@HansenPartnership.com
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I confirm Peter's observations:

> To repeat:
>
>   1. Start with an empty drive.
>   2. pktsetup 0 /dev/scd0
>   3. Insert a CD containing an isofs filesystem.
>   4. mount /dev/pktcdvd/0 /mnt/tmp
>   5. umount /mnt/tmp
>   6. Press the eject button.
>   7. Insert a DVD containing a non-writable filesystem.
>   8. mount /dev/scd0 /mnt/tmp
>   9. find /mnt/tmp -type f -print0 | xargs -0 sha1sum >/dev/null
>   10. If the DVD contains data beyond the physical size of a CD, you
>       get I/O errors in the terminal, and dmesg reports lots of
>       "attempt to access beyond end of device" errors.

This is the correct setup to trigger the bug. And the commit
6f5391c283d7fdcf24bf40786ea79061919d1e1d has nothing to do with this
bug. It was bad luck that i couldn't trigger the bug with said commit
reverted (in my tests, the second boot with the reverted commit missed
the first mount/umount smaller cd step, so...)

So sorry for all the mess and stress.

I'm glad that Peter found the real nature of this bug.

mfg
thomas
