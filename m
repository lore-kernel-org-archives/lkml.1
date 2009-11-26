Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbZKZHFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbZKZHFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758583AbZKZHFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:05:50 -0500
Received: from smtp.nokia.com ([192.100.122.230]:52967 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758584AbZKZHFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:05:49 -0500
Subject: Re: [PATCH] JFFS2: min/max confusion?
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Roel Kluin <roel.kluin@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B08088C.8050305@gmail.com>
References: <4B08088C.8050305@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Nov 2009 09:05:25 +0200
Message-Id: <1259219125.29118.41.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 26 Nov 2009 07:05:30.0416 (UTC) FILETIME=[D6DF5300:01CA6E66]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-11-21 at 16:34 +0100, Roel Kluin wrote:
> MAX_SUMMARY_SIZE was meant as a limit, not as a minimum
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  fs/jffs2/summary.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> unless I am mistaken?
> 
> diff --git a/fs/jffs2/summary.c b/fs/jffs2/summary.c
> index 6caf1e1..800171d 100644
> --- a/fs/jffs2/summary.c
> +++ b/fs/jffs2/summary.c
> @@ -23,7 +23,7 @@
>  
>  int jffs2_sum_init(struct jffs2_sb_info *c)
>  {
> -	uint32_t sum_size = max_t(uint32_t, c->sector_size, MAX_SUMMARY_SIZE);
> +	uint32_t sum_size = min_t(uint32_t, c->sector_size, MAX_SUMMARY_SIZE);
>  
>  	c->summary = kzalloc(sizeof(struct jffs2_summary), GFP_KERNEL);

This looks right, I've pushed your patch to my l2-mtd tree, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

