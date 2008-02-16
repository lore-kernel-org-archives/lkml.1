Return-Path: <linux-kernel-owner+w=401wt.eu-S932139AbYBPCsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbYBPCsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 21:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbYBPCr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 21:47:58 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:45468 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752827AbYBPCr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 21:47:57 -0500
X-Sasl-enc: EP1wI5XRwMfMRiQr/eIsf9vlvsAn+d2bvlx9Ut1p2jOv 1203130075
Subject: Re: [PATCH] autofs4: fix sparse warning in root.c
From: Ian Kent <raven@themaw.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1203126572.7442.13.camel@brick>
References: <1203126572.7442.13.camel@brick>
Content-Type: text/plain
Date: Sat, 16 Feb 2008 11:47:41 +0900
Message-Id: <1203130061.3172.8.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-15 at 17:49 -0800, Harvey Harrison wrote:
> fs/autofs4/root.c:536:23: warning: symbol 'ino' shadows an earlier one
> fs/autofs4/root.c:510:22: originally declared here
> 
> There is no need to redeclare, we are at the end of the loop and in
> the next iteration of the loop, ino will be reset.

Of course, this is fine.

But I like to leave a blank line between declarative and procedural
statements or no blank line at all if it looks natural, usually when
there are only a few lines of code.

Picky I know, but in this case I'd prefer moving the assignment down one
line.

> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  fs/autofs4/root.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
> index a54a946..1b43456 100644
> --- a/fs/autofs4/root.c
> +++ b/fs/autofs4/root.c
> @@ -533,8 +533,8 @@ static struct dentry *autofs4_lookup_unhashed(struct autofs_sb_info *sbi, struct
>  			goto next;
>  
>  		if (d_unhashed(dentry)) {
> -			struct autofs_info *ino = autofs4_dentry_ino(dentry);
>  			struct inode *inode = dentry->d_inode;
> +			ino = autofs4_dentry_ino(dentry);
>  
>  			list_del_init(&ino->rehash);
>  			dget(dentry);

