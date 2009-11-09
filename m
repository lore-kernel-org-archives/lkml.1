Return-Path: <linux-kernel-owner+w=401wt.eu-S1752639AbZKIKvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbZKIKvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 05:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbZKIKu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 05:50:58 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57347 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbZKIKu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 05:50:57 -0500
Date: Mon, 9 Nov 2009 11:50:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: NeilBrown <neilb@suse.de>
Cc: Ric Wheeler <rwheeler@redhat.com>, Rob Landley <rob@landley.net>,
       Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
Message-ID: <20091109105054.GA8750@elf.ucw.cz>
References: <20090824212518.GF29763@elf.ucw.cz>
 <20090825232601.GF4300@elf.ucw.cz>
 <4A947682.2010204@redhat.com>
 <200908262253.17886.rob@landley.net>
 <4A967175.5070700@redhat.com>
 <20090827221319.GA1601@ucw.cz>
 <4A9733C1.2070904@redhat.com>
 <20090828064449.GA27528@elf.ucw.cz>
 <ff262c08b0c3a7a9c32dabd53a4a9a27.squirrel@neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff262c08b0c3a7a9c32dabd53a4a9a27.squirrel@neil.brown.name>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> If you have a specific bug in MD code, please propose a patch.
> >
> > Interesting. So, what's technically wrong with the patch below?
> >
> 
> You mean apart from ".... that high highly undesirable ...." ??
>                                ^^^^^^^^^^^
> 

Ok, I still believe kernel documentation should be ... well... in
kernel, not in LWN article, so I fixed the patch according to your
comments.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/Documentation/filesystems/dangers.txt b/Documentation/filesystems/dangers.txt
new file mode 100644
index 0000000..14d0324
--- /dev/null
+++ b/Documentation/filesystems/dangers.txt
@@ -0,0 +1,21 @@
+There are storage devices that have highly undesirable properties when
+they are disconnected or suffer power failures while writes are in
+progress; such devices include flash devices and degraded DM/MD RAID
+4/5/6 (*) arrays.  These devices have the property of potentially
+corrupting blocks being written at the time of the power failure, and
+worse yet, amplifying the region where blocks are corrupted such that
+additional sectors are also damaged during the power failure.
+        
+Users who use such storage devices are well advised take
+countermeasures, such as the use of Uninterruptible Power Supplies,
+and making sure the flash device is not hot-unplugged while the device
+is being used.  Regular backups when using any devices, and these
+devices in particular is also a Very Good Idea.
+        
+Otherwise, file systems placed on these devices can suffer silent data
+and file system corruption.  An forced use of fsck may detect metadata
+corruption resulting in file system corruption, but will not suffice
+to detect data corruption.
+
+(*) If device failure causes the array to become degraded during or
+immediately after the power failure, the same problem can result.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
