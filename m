Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935382Ab0BZHER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 02:04:17 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:40080 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935360Ab0BZHEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 02:04:16 -0500
Date: Fri, 26 Feb 2010 08:04:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Chihau Chau <chihau@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] Staging: dream: camera: msm_camera: fix code style
	issues
Message-ID: <20100226070415.GA14036@atrey.karlin.mff.cuni.cz>
References: <1267138659-17859-1-git-send-email-chihau@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267138659-17859-1-git-send-email-chihau@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Chihau Chau <chihau@gmail.com>
> 
> This fixes some code style issues like to add one space after a while or
> switch statement and before a open parenthesis '(', and to include KERN_
> facility level in the printk() functions.
> 
> Signed-off-by: Chihau Chau <chihau@gmail.com>

ACK.

> ---
>  drivers/staging/dream/camera/msm_camera.c |   17 ++++++++++-------
>  1 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/dream/camera/msm_camera.c b/drivers/staging/dream/camera/msm_camera.c
> index 925e16c..223918f 100644
> --- a/drivers/staging/dream/camera/msm_camera.c
> +++ b/drivers/staging/dream/camera/msm_camera.c
> @@ -76,14 +76,14 @@ static LIST_HEAD(msm_sensors);
>  		list_del_init(&qcmd->list);			\
>  		kfree(qcmd);					\
>  	};							\
> -} while(0)
> +} while (0)
>  
>  #define MSM_DRAIN_QUEUE(sync, name) do {			\
>  	unsigned long flags;					\
>  	spin_lock_irqsave(&(sync)->name##_lock, flags);		\
>  	MSM_DRAIN_QUEUE_NOSYNC(sync, name);			\
>  	spin_unlock_irqrestore(&(sync)->name##_lock, flags);	\
> -} while(0)
> +} while (0)
>  
>  static int check_overlap(struct hlist_head *ptype,
>  			unsigned long paddr,
> @@ -868,7 +868,7 @@ static int msm_config_vfe(struct msm_sync *sync, void __user *arg)
>  		return -EFAULT;
>  	}
>  
> -	switch(cfgcmd.cmd_type) {
> +	switch (cfgcmd.cmd_type) {
>  	case CMD_STATS_ENABLE:
>  		axi_data.bufnum1 =
>  			msm_pmem_region_lookup(&sync->stats,
> @@ -1621,7 +1621,8 @@ static int msm_release_control(struct inode *node, struct file *filep)
>  	int rc;
>  	struct msm_control_device *ctrl_pmsm = filep->private_data;
>  	struct msm_device *pmsm = ctrl_pmsm->pmsm;
> -	printk("msm_camera: RELEASE %s\n", filep->f_path.dentry->d_name.name);
> +	printk(KERN_INFO "msm_camera: RELEASE %s\n",
> +					filep->f_path.dentry->d_name.name);
>  	rc = __msm_release(pmsm->sync);
>  	if (!rc) {
>  		MSM_DRAIN_QUEUE(&ctrl_pmsm->ctrl_q, ctrl_status_q);
> @@ -1635,7 +1636,8 @@ static int msm_release_frame(struct inode *node, struct file *filep)
>  {
>  	int rc;
>  	struct msm_device *pmsm = filep->private_data;
> -	printk("msm_camera: RELEASE %s\n", filep->f_path.dentry->d_name.name);
> +	printk(KERN_INFO "msm_camera: RELEASE %s\n",
> +					filep->f_path.dentry->d_name.name);
>  	rc = __msm_release(pmsm->sync);
>  	if (!rc) {
>  		MSM_DRAIN_QUEUE(pmsm->sync, prev_frame_q);
> @@ -1719,7 +1721,7 @@ static void msm_vfe_sync(struct msm_vfe_resp *vdata,
>  	qcmd->type = qtype;
>  
>  	if (qtype == MSM_CAM_Q_VFE_MSG) {
> -		switch(vdata->type) {
> +		switch (vdata->type) {
>  		case VFE_MSG_OUTPUT1:
>  		case VFE_MSG_OUTPUT2:
>  			qcmd_frame =
> @@ -1928,7 +1930,8 @@ static int __msm_v4l2_control(struct msm_sync *sync,
>  	memcpy(out->value, ctrl->value, ctrl->length);
>  
>  end:
> -	if (rcmd) kfree(rcmd);
> +	if (rcmd)
> +		kfree(rcmd);
>  	CDBG("__msm_v4l2_control: end rc = %d\n", rc);
>  	return rc;
>  }

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
