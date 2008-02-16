Return-Path: <linux-kernel-owner+w=401wt.eu-S1764532AbYBPDY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764532AbYBPDY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 22:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbYBPDYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 22:24:11 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35467 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753460AbYBPDYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 22:24:09 -0500
X-Sasl-enc: 3cbH7AGCp1FpFqzol7f1bq7GYu01Pm41FghwteoNI3f+ 1203132248
Subject: Re: [PATCHv2] autofs4: fix sparse warning in root.c
From: Ian Kent <raven@themaw.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1203130296.7442.22.camel@brick>
References: <1203126572.7442.13.camel@brick>
	 <1203130061.3172.8.camel@raven.themaw.net> <1203130296.7442.22.camel@brick>
Content-Type: text/plain
Date: Sat, 16 Feb 2008 12:23:53 +0900
Message-Id: <1203132233.3172.33.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-15 at 18:51 -0800, Harvey Harrison wrote:
> fs/autofs4/root.c:536:23: warning: symbol 'ino' shadows an earlier one
> fs/autofs4/root.c:510:22: originally declared here
> 
> There is no need to redeclare, we are at the end of the loop and in
> the next iteration of the loop, ino will be reset.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Ian Kent <raven@themaw.net>
> ---
>  fs/autofs4/root.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
> index a54a946..aa4c5ff 100644
> --- a/fs/autofs4/root.c
> +++ b/fs/autofs4/root.c
> @@ -533,9 +533,9 @@ static struct dentry *autofs4_lookup_unhashed(struct autofs_sb_info *sbi, struct
>  			goto next;
>  
>  		if (d_unhashed(dentry)) {
> -			struct autofs_info *ino = autofs4_dentry_ino(dentry);
>  			struct inode *inode = dentry->d_inode;
>  
> +			ino = autofs4_dentry_ino(dentry);
>  			list_del_init(&ino->rehash);
>  			dget(dentry);
>  			/*

