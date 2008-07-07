Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbYGGPzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbYGGPzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 11:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYGGPzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 11:55:09 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57486 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbYGGPzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 11:55:07 -0400
Date: Mon, 7 Jul 2008 10:54:52 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Emelianov <xemul@openvz.org>
Subject: Re: [PATCH] devcgroup: code cleanup
Message-ID: <20080707155452.GG11250@us.ibm.com>
References: <486F1509.4020509@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486F1509.4020509@cn.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Li Zefan (lizf@cn.fujitsu.com):
> - remove a redundant memset()
> - use simple_strtoul() to parse major/minor
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks, all look good.

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks
-serge

> ---
>  security/device_cgroup.c |   15 +++------------
>  1 files changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index ddd92ce..98826b0 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -188,7 +188,7 @@ static struct cgroup_subsys_state *devcgroup_create(struct cgroup_subsys *ss,
>  		}
>  		wh->minor = wh->major = ~0;
>  		wh->type = DEV_ALL;
> -		wh->access = ACC_MKNOD | ACC_READ | ACC_WRITE;
> +		wh->access = ACC_MASK;
>  		list_add(&wh->list, &dev_cgroup->whitelist);
>  	} else {
>  		parent_dev_cgroup = cgroup_to_devcgroup(parent_cgroup);
> @@ -250,7 +250,6 @@ static char type_to_char(short type)
> 
>  static void set_majmin(char *str, unsigned m)
>  {
> -	memset(str, 0, MAJMINLEN);
>  	if (m == ~0)
>  		sprintf(str, "*");
>  	else
> @@ -405,11 +404,7 @@ static ssize_t devcgroup_access_write(struct cgroup *cgroup, struct cftype *cft,
>  		wh.major = ~0;
>  		b++;
>  	} else if (isdigit(*b)) {
> -		wh.major = 0;
> -		while (isdigit(*b)) {
> -			wh.major = wh.major*10+(*b-'0');
> -			b++;
> -		}
> +		wh.major = simple_strtoul(b, &b, 0);
>  	} else {
>  		retval = -EINVAL;
>  		goto out2;
> @@ -425,11 +420,7 @@ static ssize_t devcgroup_access_write(struct cgroup *cgroup, struct cftype *cft,
>  		wh.minor = ~0;
>  		b++;
>  	} else if (isdigit(*b)) {
> -		wh.minor = 0;
> -		while (isdigit(*b)) {
> -			wh.minor = wh.minor*10+(*b-'0');
> -			b++;
> -		}
> +		wh.minor = simple_strtoul(b, &b, 0);
>  	} else {
>  		retval = -EINVAL;
>  		goto out2;
> -- 
> 1.5.4.rc3
