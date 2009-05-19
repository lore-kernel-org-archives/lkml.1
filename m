Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbZESBNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbZESBNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 21:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZESBNC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 21:13:02 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61128 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbZESBNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 21:13:01 -0400
Message-ID: <4A1207DE.4000409@cn.fujitsu.com>
Date: Tue, 19 May 2009 09:14:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: raspl@linux.vnet.ibm.com
CC: linux-btrace@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
Subject: Re: [Patch] Remove debugfs entries on bad path
References: <4A115BA5.6090905@linux.vnet.ibm.com>
In-Reply-To: <4A115BA5.6090905@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A better title:
	[Patch] blktrace: remove debugfs entries on bad path

Stefan Raspl wrote:
> debugfs directory entries for devices are not removed on bad path.

Can you be more elaborate on how to reproduce this issue?

> If so, subsequent attempts to start blktrace on the respective
> devices will not succeed due to existing directories.
> 
> Signed-off-by: Stefan Raspl <stefan.raspl@linux.vnet.ibm.com>
> 
> ---
>  kernel/trace/blktrace.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -262,6 +262,7 @@ static void blk_trace_free(struct blk_tr
>  {
>  	debugfs_remove(bt->msg_file);
>  	debugfs_remove(bt->dropped_file);
> +	debugfs_remove(bt->dir);
>  	relay_close(bt->rchan);
>  	free_percpu(bt->sequence);
>  	free_percpu(bt->msg_data);
> 

