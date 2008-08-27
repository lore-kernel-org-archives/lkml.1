Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbYH0Rvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbYH0Rvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 13:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYH0Rvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 13:51:37 -0400
Received: from ns1.suse.de ([195.135.220.2]:34000 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbYH0Rvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 13:51:37 -0400
Date: Wed, 27 Aug 2008 19:51:34 +0200
From: Karsten Keil <kkeil@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Karsten Keil <kkeil@suse.de>,
       isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 10/59] CRED: Wrap task credential accesses in the ISDN drivers
Message-ID: <20080827175134.GA15907@pingi.kke.suse.de>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk> <20080827134633.19980.81789.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827134633.19980.81789.stgit@warthog.procyon.org.uk>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.60-0.27-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 02:46:33PM +0100, David Howells wrote:
> Wrap access to task credentials so that they can be separated more easily from
> the task_struct during the introduction of COW creds.
> 
> Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().
> 
> Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
> sense to use RCU directly rather than a convenient wrapper; these will be
> addressed by later patches.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: James Morris <jmorris@namei.org>
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> Cc: Karsten Keil <kkeil@suse.de>
> Cc: isdn4linux@listserv.isdn4linux.de
> ---
> 
>  drivers/isdn/capi/capifs.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/drivers/isdn/capi/capifs.c b/drivers/isdn/capi/capifs.c
> index 550e80f..0aa66ec 100644
> --- a/drivers/isdn/capi/capifs.c
> +++ b/drivers/isdn/capi/capifs.c
> @@ -156,8 +156,8 @@ void capifs_new_ncci(unsigned int number, dev_t device)
>  	if (!inode)
>  		return;
>  	inode->i_ino = number+2;
> -	inode->i_uid = config.setuid ? config.uid : current->fsuid;
> -	inode->i_gid = config.setgid ? config.gid : current->fsgid;
> +	inode->i_uid = config.setuid ? config.uid : current_fsuid();
> +	inode->i_gid = config.setgid ? config.gid : current_fsgid();
>  	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
>  	init_special_inode(inode, S_IFCHR|config.mode, device);
>  	//inode->i_op = &capifs_file_inode_operations;


Acked

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
