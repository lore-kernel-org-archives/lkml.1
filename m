Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbYFZEYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbYFZEYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 00:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbYFZEYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 00:24:36 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:45167 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbYFZEYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 00:24:36 -0400
Message-ID: <48631A01.1020009@skyrush.com>
Date: Wed, 25 Jun 2008 22:24:33 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080620)
MIME-Version: 1.0
To: free_beer_for_all@yahoo.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
References: <943360.32984.qm@web46103.mail.sp1.yahoo.com>
In-Reply-To: <943360.32984.qm@web46103.mail.sp1.yahoo.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

barry bouwsma wrote:
> I think 100% of it refers to GMT+2
> (in my present time zone), so I wonder if in different languages,
> there's a preference for casual use of the phrase GMT (a quick
> look in my dictionary shows an entry for GMT, nothing for UTC,
> but then, it has no entry for `operating system' or its translated
> equivalent.

Well, your question certainly prompted me to go and read up on it again.
 In my work (unmanned space missions - solar system stuff), we deal with
many representations of time, and so I am used to being anal about it.
For example, there is GMT, UTC, TDT, ET, etc.  They all differ ever so
slightly.

> --- /mnt/usr/local/src/linux-2.6.24/fs/fat/inode.c-DIST 2008-01-30 10:59:19.000000000 +0100
> +++ /mnt/usr/local/src/linux-2.6.24/fs/fat/inode.c      2008-04-13 07:09:10.000000000 +0200
> @@ -826,6 +829,9 @@ static int fat_show_options(struct seq_f
>                 seq_puts(m, ",showexec");
>         if (opts->sys_immutable)
>                 seq_puts(m, ",sys_immutable");
> +/* XXX HACK */
> +       if (opts->utc)
> +               seq_puts(m, ",utc");
>         if (!isvfat) {
>                 if (opts->dotsOK)
>                         seq_puts(m, ",dotsOK=yes");
> 

Indeed!  Thanks, I'll put this in the patch.  The above is actually not
needed for the mount command or /etc/mtab, but it *is* used for, e.g.,
/proc/mounts.

						-Joe
