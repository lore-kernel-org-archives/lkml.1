Return-Path: <linux-kernel-owner+w=401wt.eu-S1762625AbYBNJbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762625AbYBNJbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 04:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbYBNJbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 04:31:21 -0500
Received: from trashmail.net ([213.155.82.90]:35821 "EHLO trashmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbYBNJbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 04:31:20 -0500
To: linux-kernel@vger.kernel.org
From: rzryyvzy <rzryyvzy@trashmail.net>
Subject: Is there a "blackhole" /dev/null directory?
Message-Id: <20080214093051.7240852AB0E31@trashmail.net>
Date: Thu, 14 Feb 2008 10:30:51 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linux Kernel Hackers,

/dev/null is often very useful, specially if programs force to save data in some file. But some programs like to creates different temporary file names, so /dev/null could no more work.

What is with a "/dev/null"-directory?
I mean a "blackhole pseudo directory" which eats every write to null.

Here is how it could work:
mount -t nulldir nulldir /dev/nulldir

Now if a program does a create(2),
it creates in the memory the file with its fd.
Then if a program does a write(2) to the fd, it eats the writes and give out fakely it has written the number of bytes.
When the program calls does a close(2) of the fd, then the complete inode is deleted in the memory.

The directory should  be permanently empty except for the inodes with open file descriptors. So only inode information would be temporary saved in this "nulldir tmpfs" directory.

Is there already existing a possibility to create a null directory?
-- 
Best regards,
Mika Lawando

-- 
E-Mail sent with anti-spam site TrashMail.net!
Free disposable email addresses: http://www.trashmail.net/
