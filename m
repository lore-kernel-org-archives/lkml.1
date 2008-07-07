Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbYGGPtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbYGGPtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 11:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbYGGPtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 11:49:16 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55095 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbYGGPtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 11:49:16 -0400
Date: Mon, 7 Jul 2008 10:48:59 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Emelianov <xemul@openvz.org>
Subject: Re: [PATCH 2/2] devcgroup: fix permission check when adding entry
	to child cgroup
Message-ID: <20080707154859.GF11250@us.ibm.com>
References: <486F091C.8050803@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486F091C.8050803@cn.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Li Zefan (lizf@cn.fujitsu.com):
>  # cat devices.list
>  c 1:3 r
>  # echo 'c 1:3 w' > sub/devices.allow
>  # cat sub/devices.list
>  c 1:3 w
> 
> As illustrated, the parent group has no write permission to /dev/null,
> so its child should not be allowed to add this write permission,
> which is documented in Documentation/controllers/devices.txt.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

I have no idea where that came from (but see that it was in my original
submission).  Maybe I meant to do &, but that still isn't necessary.

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge

> ---
>  security/device_cgroup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index 1e2e28a..ddd92ce 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -300,7 +300,7 @@ static int may_access_whitelist(struct dev_cgroup *c,
>  			continue;
>  		if (whitem->minor != ~0 && whitem->minor != refwh->minor)
>  			continue;
> -		if (refwh->access & (~(whitem->access | ACC_MASK)))
> +		if (refwh->access & (~whitem->access))
>  			continue;
>  		return 1;
>  	}
> -- 
> 1.5.4.rc3
