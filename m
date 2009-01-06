Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbZAFJUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbZAFJUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZAFJTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:19:55 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56154 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbZAFJTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:19:51 -0500
Date: Tue, 6 Jan 2009 10:21:56 +0100
From: Pavel Machek <pavel@suse.cz>
To: Theodore Tso <tytso@mit.edu>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: [patch] document ext3 a bit better
Message-ID: <20090106092156.GA13737@elf.ucw.cz>
References: <20090103123813.GA1512@ucw.cz> <20090104023211.GJ4758@mit.edu> <20090104223433.GC1913@elf.ucw.cz> <20090105145713.GB4116@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105145713.GB4116@mit.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-01-05 09:57:13, Theodore Tso wrote:
> On Sun, Jan 04, 2009 at 11:34:33PM +0100, Pavel Machek wrote:
> > @@ -14,6 +14,11 @@ Options
> >  When mounting an ext3 filesystem, the following option are accepted:
> >  (*) == default
> >  
> > +ro			Mount filesystem read only. Note that ext3 will replay
> > +			the journal (and thus write to the partition) even when
> > +			mounted "read only". "ro, noload" can be used to prevent
> > +			writes to the filesystem.
> 
> I'd sugest "ro,noload" since the spaces screw up the mount options
> parsing both on the command-line and in /etc/fstab.  So how about:
> 
> 	Using the mount options "ro,noload" can be used....

Too many "using", but yes, fixed, thanks.

> > @@ -95,6 +102,8 @@ debug			Extra debugging information is s
> >  errors=remount-ro(*)	Remount the filesystem read-only on an error.
> >  errors=continue		Keep going on a filesystem error.
> >  errors=panic		Panic and halt the machine if an error occurs.
> > +			(Note that default is overriden by superblock
> > +			setting on most systems).
> 
> The default is always specified by the superblock setting.  So users
> will probably find it easier to understand if we remove the "(*)" and
> to add the explanatory comment:
> 
> 			(These mount options override the errors behavior
> 			specified in the superblock, which can be configured
> 			using tune2fs)
> 
> Pavel, thanks for working on improving the documentation; with these
> fixes,

Thanks!

---

ext3 has quite unexpected semantics or "ro" and defaults are
not what they are documented to be, due to mkfs override.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
index 9dd2a3b..49c08bf 100644
--- a/Documentation/filesystems/ext3.txt
+++ b/Documentation/filesystems/ext3.txt
@@ -14,6 +14,11 @@ Options
 When mounting an ext3 filesystem, the following option are accepted:
 (*) == default
 
+ro			Mount filesystem read only. Note that ext3 will replay
+			the journal (and thus write to the partition) even when
+			mounted "read only". Mount options "ro,noload" can be
+			used to prevent writes to the filesystem.
+
 journal=update		Update the ext3 file system's journal to the current
 			format.
 
@@ -27,7 +32,9 @@ journal_dev=devnum	When the external jou
 			identified through its new major/minor numbers encoded
 			in devnum.
 
-noload			Don't load the journal on mounting.
+noload			Don't load the journal on mounting. Note that this forces
+			mount of inconsistent filesystem, which can lead to
+			various problems.
 
 data=journal		All data are committed into the journal prior to being
 			written into the main file system.
@@ -92,9 +99,12 @@ nocheck
 
 debug			Extra debugging information is sent to syslog.
 
-errors=remount-ro(*)	Remount the filesystem read-only on an error.
+errors=remount-ro	Remount the filesystem read-only on an error.
 errors=continue		Keep going on a filesystem error.
 errors=panic		Panic and halt the machine if an error occurs.
+			(These mount options override the errors behavior
+			specified in the superblock, which can be 
+			configured using tune2fs.)			
 
 data_err=ignore(*)	Just print an error message if an error occurs
 			in a file data buffer in ordered mode.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
