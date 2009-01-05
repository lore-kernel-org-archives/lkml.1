Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbZAEO57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbZAEO57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbZAEO5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:57:51 -0500
Received: from thunk.org ([69.25.196.29]:45683 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613AbZAEO5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:57:50 -0500
Date: Mon, 5 Jan 2009 09:57:13 -0500
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       mtk.manpages@gmail.com, rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: [patch] document ext3 a bit better
Message-ID: <20090105145713.GB4116@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <20090103123813.GA1512@ucw.cz> <20090104023211.GJ4758@mit.edu> <20090104223433.GC1913@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104223433.GC1913@elf.ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 11:34:33PM +0100, Pavel Machek wrote:
> @@ -14,6 +14,11 @@ Options
>  When mounting an ext3 filesystem, the following option are accepted:
>  (*) == default
>  
> +ro			Mount filesystem read only. Note that ext3 will replay
> +			the journal (and thus write to the partition) even when
> +			mounted "read only". "ro, noload" can be used to prevent
> +			writes to the filesystem.

I'd sugest "ro,noload" since the spaces screw up the mount options
parsing both on the command-line and in /etc/fstab.  So how about:

	Using the mount options "ro,noload" can be used....

> @@ -95,6 +102,8 @@ debug			Extra debugging information is s
>  errors=remount-ro(*)	Remount the filesystem read-only on an error.
>  errors=continue		Keep going on a filesystem error.
>  errors=panic		Panic and halt the machine if an error occurs.
> +			(Note that default is overriden by superblock
> +			setting on most systems).

The default is always specified by the superblock setting.  So users
will probably find it easier to understand if we remove the "(*)" and
to add the explanatory comment:

			(These mount options override the errors behavior
			specified in the superblock, which can be configured
			using tune2fs)

Pavel, thanks for working on improving the documentation; with these
fixes,

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

							- Ted
