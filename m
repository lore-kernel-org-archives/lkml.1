Return-Path: <linux-kernel-owner+w=401wt.eu-S1765992AbXGYOLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765992AbXGYOLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbXGYOLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:11:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277AbXGYOLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:11:08 -0400
Subject: Re: [PATCH] gfs2/locking/dlm: use an temp variable to reduce a
	spin_unlock
From: Steven Whitehouse <swhiteho@redhat.com>
To: Denis Cheng <crquan@gmail.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <11853572382497-git-send-email-crquan@gmail.com>
References: <11853572382497-git-send-email-crquan@gmail.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Wed, 25 Jul 2007 15:09:36 +0100
Message-Id: <1185372576.8765.477.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now applied to the GFS2 -nmw git tree. Thanks,

Steve.

On Wed, 2007-07-25 at 17:53 +0800, Denis Cheng wrote:
> this is more clear.
> 
> Signed-off-by: Denis Cheng <crquan@gmail.com>
> ---
>  fs/gfs2/locking/dlm/plock.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/gfs2/locking/dlm/plock.c b/fs/gfs2/locking/dlm/plock.c
> index fba1f1d..1f7b038 100644
> --- a/fs/gfs2/locking/dlm/plock.c
> +++ b/fs/gfs2/locking/dlm/plock.c
> @@ -346,15 +346,16 @@ static ssize_t dev_write(struct file *file, const char __user *u, size_t count,
>  
>  static unsigned int dev_poll(struct file *file, poll_table *wait)
>  {
> +	unsigned int mask = 0;
> +
>  	poll_wait(file, &send_wq, wait);
>  
>  	spin_lock(&ops_lock);
> -	if (!list_empty(&send_list)) {
> -		spin_unlock(&ops_lock);
> -		return POLLIN | POLLRDNORM;
> -	}
> +	if (!list_empty(&send_list))
> +		mask = POLLIN | POLLRDNORM;
>  	spin_unlock(&ops_lock);
> -	return 0;
> +
> +	return mask;
>  }
>  
>  static const struct file_operations dev_fops = {

