Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbYLBMFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbYLBMFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 07:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYLBME5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 07:04:57 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39913 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbYLBME4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 07:04:56 -0500
Date: Tue, 2 Dec 2008 13:06:46 +0100
From: Pavel Machek <pavel@suse.cz>
To: mtk.manpages@gmail.com, linux-doc@vger.kernel.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: fsync.2 does not mention error handling
Message-ID: <20081202120645.GA5327@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fsync() transfers ("flushes") all modified in-core data of (i.e.,
modified buffer cache pages for) the file referred to by the file
descriptor fd to the disk device (or other permanent storage device)
where that file resides.  The call blocks until the device reports
that the transfer has completed.  It also flushes metadata information
associated with the file (see stat(2)).

Calling fsync() does not necessarily ensure that the entry in the
directory containing the file has also reached disk.  For that an
explicit fsync() on a file descriptor for the directory is also
needed.

...
RETURN VALUE         top

On success, these system calls return zero.  On error, -1 is
returned, and errno is set appropriately.


--------------


I guess it should mention that any errors during fsync are only
mentioned to the first process calling it... which means that if you

write file
fsync file
fsync .

... and someone else does "fsync ." in the meantime, you may get
success when in fact directory entry of file is not written to the
disk.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
