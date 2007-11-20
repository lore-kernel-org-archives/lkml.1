Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbXKTXDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbXKTXDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbXKTXDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:03:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43332 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbXKTXDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:03:33 -0500
Date: Wed, 21 Nov 2007 00:03:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] proc: Fix the threaded /proc/self.
Message-ID: <20071120230306.GE24380@elte.hu>
References: <20071119191000.GA1560@elf.ucw.cz> <200711192304.25087.rjw@sisk.pl> <4743026B.2020907@openvz.org> <m11wakshyz.fsf@ebiederm.dsl.xmission.com> <20071120215914.GE24156@elte.hu> <m1k5ocr14n.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1k5ocr14n.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> We may be stuck with the current broken behavior for backwards 
> compatibility reasons but lets try fixing our ancient bug for the 
> 2.6.25 time frame and see if anyone screams.

to make sure i got you right - do you agree that this is a regression 
and that we need the patch below included in 2.6.24?

> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Ingo Molnar <mingo@elte.hu>

> ---
>  fs/proc/base.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 34a1821..8502436 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2050,22 +2050,22 @@ static int proc_self_readlink(struct dentry *dentry, char __user *buffer,
>  			      int buflen)
>  {
>  	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
> -	pid_t tgid = task_tgid_nr_ns(current, ns);
> +	pid_t pid = task_pid_nr_ns(current, ns);
>  	char tmp[PROC_NUMBUF];
> -	if (!tgid)
> +	if (!pid)
>  		return -ENOENT;
> -	sprintf(tmp, "%d", tgid);
> +	sprintf(tmp, "%d", pid);
>  	return vfs_readlink(dentry,buffer,buflen,tmp);
>  }
>  
>  static void *proc_self_follow_link(struct dentry *dentry, struct nameidata *nd)
>  {
>  	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
> -	pid_t tgid = task_tgid_nr_ns(current, ns);
> +	pid_t pid = task_pid_nr_ns(current, ns);
>  	char tmp[PROC_NUMBUF];
> -	if (!tgid)
> +	if (!pid)
>  		return ERR_PTR(-ENOENT);
> -	sprintf(tmp, "%d", task_tgid_nr_ns(current, ns));
> +	sprintf(tmp, "%d", pid);
>  	return ERR_PTR(vfs_follow_link(nd,tmp));
>  }
>  
> -- 
> 1.5.3.rc6.17.g1911

	Ingo
