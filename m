Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbZAKSwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbZAKSwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 13:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbZAKSvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 13:51:55 -0500
Received: from smtp.cs.aau.dk ([130.225.194.6]:34817 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbZAKSvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 13:51:55 -0500
Subject: Re: [PATCH -next] jbd2: fix printk format warning
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org
In-Reply-To: <20090105121158.94d990c3.randy.dunlap@oracle.com>
References: <20090105173517.deeff918.sfr@canb.auug.org.au>
	 <20090105121158.94d990c3.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 11 Jan 2009 19:52:53 +0100
Message-Id: <1231699973.17759.22.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

man, 05 01 2009 kl. 12:11 -0800, skrev Randy Dunlap:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix jbd2 printk format:
> 
> fs/jbd2/journal.c:848: warning: format '%lu' expects type 'long unsigned int',
> but argument 3 has type 'uint32_t'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  fs/jbd2/journal.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- linux-next-20090105.orig/fs/jbd2/journal.c
> +++ linux-next-20090105/fs/jbd2/journal.c
> @@ -845,7 +845,8 @@ static int jbd2_seq_info_show(struct seq
>  	seq_printf(seq, "  %ums logging transaction\n",
>  	    jiffies_to_msecs(s->stats->u.run.rs_logging / s->stats->ts_tid));
>  	seq_printf(seq, "  %luus average transaction commit time\n",
> -		   do_div(s->journal->j_average_commit_time, 1000));
> +		   (unsigned long)do_div(s->journal->j_average_commit_time,
> +					1000));
>  	seq_printf(seq, "  %lu handles per transaction\n",
>  	    s->stats->u.run.rs_handle_count / s->stats->ts_tid);
>  	seq_printf(seq, "  %lu blocks per transaction\n",

This patch is just as wrong as the original code. Please don't
apply it, but see my "[PATCH] jbd2: fix wrong use of do_div"
that I just sent out.


Simon Holm Thøgersen

