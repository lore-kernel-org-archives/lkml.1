Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbZKTV1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbZKTV1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbZKTV1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:27:31 -0500
Received: from cantor.suse.de ([195.135.220.2]:55909 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbZKTV1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:27:30 -0500
Date: Fri, 20 Nov 2009 22:27:32 +0100
From: Jan Kara <jack@suse.cz>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Jamie Lokier <jamie@shareable.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Petr Vandrovec <vandrove@vc.cvut.cz>, Anders Larsen <al@alarsen.net>,
       Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 13/15] Do not fallback to default_llseek() when
 readdir() uses BKL
Message-ID: <20091120212732.GD15631@duck.suse.cz>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de>
 <1258735245-25826-14-git-send-email-jblunck@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258735245-25826-14-git-send-email-jblunck@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 20-11-09 17:40:43, Jan Blunck wrote:
> Do not use the fallback default_llseek() if the readdir operation of the
> filesystem still uses the big kernel lock. Since llseek() modifies
> file->f_pos of the directory directly it may need locking to not confuse
> readdir which usually uses file->f_pos directly as well. Since the special
> characteristics of the BKL (unlocked on schedule) are not necessary in this
> case, the inode mutex can be used for locking as provided by
> generic_file_llseek(). This is only possible since all filesystems, except
> reiserfs, either use a directory as a flat file or with disk address
> offsets. Reiserfs on the other hand uses a 32bit hash off the filename as
> the offset so generic_file_llseek() can get used as well since the hash is
> always smaller than sb->s_maxbytes (= (512 << 32) - blocksize).
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> ---
>  fs/udf/dir.c              |    1 +
For the UDF part:

  Acked-by: Jan Kara <jack@suse.cz>

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
