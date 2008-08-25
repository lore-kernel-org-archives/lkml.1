Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbYHYQnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbYHYQnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 12:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbYHYQn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 12:43:28 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45235 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbYHYQn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 12:43:27 -0400
Date: Mon, 25 Aug 2008 11:43:26 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] devcgroup: use kmemdup()
Message-ID: <20080825164326.GB13583@us.ibm.com>
References: <48B21756.4020208@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B21756.4020208@cn.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Li Zefan (lizf@cn.fujitsu.com):
> This saves 40 bytes on my x86_32 box.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  security/device_cgroup.c |    9 ++-------
>  1 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index 46f2397..9c625f6 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -84,13 +84,9 @@ static int dev_whitelist_copy(struct list_head *dest, struct list_head *orig)
>  	struct dev_whitelist_item *wh, *tmp, *new;
> 
>  	list_for_each_entry(wh, orig, list) {
> -		new = kmalloc(sizeof(*wh), GFP_KERNEL);
> +		new = kmemdup(wh, sizeof(*wh), GFP_KERNEL);
>  		if (!new)
>  			goto free_and_exit;
> -		new->major = wh->major;
> -		new->minor = wh->minor;
> -		new->type = wh->type;
> -		new->access = wh->access;
>  		list_add_tail(&new->list, dest);
>  	}
> 
> @@ -114,11 +110,10 @@ static int dev_whitelist_add(struct dev_cgroup *dev_cgroup,
>  {
>  	struct dev_whitelist_item *whcopy, *walk;
> 
> -	whcopy = kmalloc(sizeof(*whcopy), GFP_KERNEL);
> +	whcopy = kmemdup(wh, sizeof(*wh), GFP_KERNEL);
>  	if (!whcopy)
>  		return -ENOMEM;
> 
> -	memcpy(whcopy, wh, sizeof(*whcopy));
>  	spin_lock(&dev_cgroup->lock);
>  	list_for_each_entry(walk, &dev_cgroup->whitelist, list) {
>  		if (walk->type != wh->type)
> -- 
> 1.5.4.rc3
