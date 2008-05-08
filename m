Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbYEHNR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbYEHNR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbYEHNRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:17:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbYEHNRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:17:16 -0400
Subject: Re: [PATCH 1/2] [fs-devel] the real needs of just_schedule
From: Steven Whitehouse <swhiteho@redhat.com>
To: Denis Cheng <crquan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1210096264-27426-1-git-send-email-crquan@gmail.com>
References: <1210096264-27426-1-git-send-email-crquan@gmail.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Thu, 08 May 2008 14:11:52 +0100
Message-Id: <1210252312.3635.484.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2008-05-07 at 01:51 +0800, Denis Cheng wrote:
> there are some situations which really need a just schedule,
> with int return value;
> and this should be moved into lib/ in the future.
> 
> Signed-off-by: Denis Cheng <crquan@gmail.com>
> ---
>  fs/inode.c                |    2 +-
>  include/linux/writeback.h |   16 ++++++++++++----
>  2 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index bf64781..b355a44 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1291,7 +1291,7 @@ int inode_needs_sync(struct inode *inode)
>  
>  EXPORT_SYMBOL(inode_needs_sync);
>  
> -int inode_wait(void *word)
> +int just_schedule(void *word)
>  {
>  	schedule();
>  	return 0;
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index f462439..80ff5eb 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -67,23 +67,31 @@ struct writeback_control {
>  
>  /*
>   * fs/fs-writeback.c
> - */	
> + */
>  void writeback_inodes(struct writeback_control *wbc);
> -int inode_wait(void *);
>  void sync_inodes_sb(struct super_block *, int wait);
>  void sync_inodes(int wait);
>  
> +/*
> + * fs/inode.c
> + *
> + * there are some situations which really need a just schedule,
> + * with int return value;
> + * and this should be moved into lib/ in the future.
> + */
> +int just_schedule(void *);
> +
Why is now not a good time? :-)

The patches look ok to me otherwise, but I wonder whether I should put
them in my tree (since they affect core code) or whether they'd be
better in -mm and/or linux-next?

Steve.


