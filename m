Return-Path: <linux-kernel-owner+w=401wt.eu-S934685AbYBTUns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934685AbYBTUns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761297AbYBTUnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:43:32 -0500
Received: from mx2.netapp.com ([216.240.18.37]:28163 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758296AbYBTUna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:43:30 -0500
X-IronPort-AV: E=Sophos;i="4.25,382,1199692800"; 
   d="scan'208";a="154495731"
Subject: Re: [PATCH 1/4] nfs: fix sparse warning in nfs4state.c
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1203538246.25307.14.camel@brick>
References: <1203538246.25307.14.camel@brick>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Wed, 20 Feb 2008 15:43:26 -0500
Message-Id: <1203540206.17505.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 20 Feb 2008 20:43:28.0200 (UTC) FILETIME=[3F121C80:01C87401]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-20 at 12:10 -0800, Harvey Harrison wrote:
> fs/nfs/nfs4state.c:788:34: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  fs/nfs/nfs4state.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
> index 6233eb5..b962397 100644
> --- a/fs/nfs/nfs4state.c
> +++ b/fs/nfs/nfs4state.c
> @@ -785,7 +785,7 @@ static int nfs4_reclaim_locks(struct nfs4_state_recovery_ops *ops, struct nfs4_s
>  	struct file_lock *fl;
>  	int status = 0;
>  
> -	for (fl = inode->i_flock; fl != 0; fl = fl->fl_next) {
> +	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
>  		if (!(fl->fl_flags & (FL_POSIX|FL_FLOCK)))
>  			continue;
>  		if (nfs_file_open_context(fl->fl_file)->state != state)

Could you please just wrap these 4 up into a single patch? They are all
fixing up the same issue, and they are trivial to review, so there is
very little benefit in separating them.

Thanks
  Trond
