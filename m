Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZGNOLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZGNOLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 10:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZGNOLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 10:11:03 -0400
Received: from cmpxchg.org ([85.214.51.133]:35215 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085AbZGNOLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 10:11:01 -0400
Date: Tue, 14 Jul 2009 16:10:28 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: sysfs fix mismatched queue_var_{store,show} in 64bit kernel
Message-ID: <20090714141028.GB18146@cmpxchg.org>
References: <1247572618-24073-1-git-send-email-dfeng@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247572618-24073-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 07:56:58PM +0800, Xiaotian Feng wrote:
> In blk-sysfs.c, queue_var_store uses unsigned long to store data,
> but queue_var_show uses unsigned int to show data. This causes,
> 
> 	# echo 70000000000 > /sys/block/<dev>/queue/read_ahead_kb
> 	# cat /sys/block/<dev>/queue/read_ahead_kb => get wrong value
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> ---
>  block/blk-sysfs.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index b1cd040..e177eb3 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -16,9 +16,9 @@ struct queue_sysfs_entry {
>  };
>  
>  static ssize_t
> -queue_var_show(unsigned int var, char *page)
> +queue_var_show(unsigned long var, char *page)
>  {
> -	return sprintf(page, "%d\n", var);
> +	return sprintf(page, "lu\n", var);

%lu, I guess?
