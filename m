Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbZJYTDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbZJYTDi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 15:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbZJYTDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 15:03:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40156 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbZJYTDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 15:03:37 -0400
Date: Sun, 25 Oct 2009 07:21:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext2: Avoid WARN() messages when failing to write to
	the superblock
Message-ID: <20091025062128.GA1391@ucw.cz>
References: <1256016146-2677-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256016146-2677-1-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-10-20 01:22:26, Theodore Ts'o wrote:
> This fixes a common warning reported by kerneloops.org
> 

> +static void ext2_clear_super_error(struct super_block * sb)
> +{
> +	struct buffer_head *sbh = EXT2_SB(sb)->s_sbh;
> +
> +	if (buffer_write_io_error(sbh)) {
> +		/*
> +		 * Oh, dear.  A previous attempt to write the
> +		 * superblock failed.  This could happen because the
> +		 * USB device was yanked out.  Or it could happen to
> +		 * be a transient write error and maybe the block will
> +		 * be remapped.  Nothing we can do but to retry the
> +		 * write and hope for the best.
> +		 */
> +		printk(KERN_ERR "EXT2-fs: %s previous I/O error to "
> +		       "superblock detected", sb->s_id);

KERN_ALERT/KERN_CRITICAL?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
