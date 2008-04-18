Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbYDRQn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbYDRQn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 12:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbYDRQnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 12:43:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474AbYDRQnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 12:43:21 -0400
Subject: Re: [PATCH] gfs2: fix assertion in log_refund()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: cluster-devel@redhat.com, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <48076BF1.9080204@tiscali.nl>
References: <48076BF1.9080204@tiscali.nl>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Fri, 18 Apr 2008 17:42:05 +0100
Message-Id: <1208536925.3635.412.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now in the GFS2 -nmw git tree, which I'm just about to send a pull
request for,

Steve.

On Thu, 2008-04-17 at 17:25 +0200, Roel Kluin wrote:
> since unsigned, unused >= 0 is always true.
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
> index 161ab6f..211dc2d 100644
> --- a/fs/gfs2/log.c
> +++ b/fs/gfs2/log.c
> @@ -769,8 +769,8 @@ static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
>  	sdp->sd_log_commited_revoke += tr->tr_num_revoke - tr->tr_num_revoke_rm;
>  	gfs2_assert_withdraw(sdp, ((int)sdp->sd_log_commited_revoke) >= 0);
>  	reserved = calc_reserved(sdp);
> +	gfs2_assert_withdraw(sdp, sdp->sd_log_blks_reserved + tr->tr_reserved >= reserved);
>  	unused = sdp->sd_log_blks_reserved - reserved + tr->tr_reserved;
> -	gfs2_assert_withdraw(sdp, unused >= 0);
>  	atomic_add(unused, &sdp->sd_log_blks_free);
>  	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) <=
>  			     sdp->sd_jdesc->jd_blocks);

