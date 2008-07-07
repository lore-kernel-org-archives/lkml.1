Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbYGGPqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbYGGPqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 11:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbYGGPqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 11:46:36 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38000 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608AbYGGPqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 11:46:35 -0400
Date: Mon, 7 Jul 2008 10:46:33 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Emelianov <xemul@openvz.org>
Subject: Re: [PATCH 1/2] devcgroup: always show unsigned major/minor num
Message-ID: <20080707154633.GE11250@us.ibm.com>
References: <486F0918.5090707@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486F0918.5090707@cn.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Li Zefan (lizf@cn.fujitsu.com):
>  # echo "b $((0x7fffffff)):$((0x80000000)) rwm" > devices.allow
>  # cat devices.list
>  b 214748364:-21474836 rwm
> 
> though a major/minor number of 0x800000000 is meaningless, we
> should not cast it to a negative value.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

makes sense.

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge

> ---
>  security/device_cgroup.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index fd764a0..1e2e28a 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -222,7 +222,7 @@ static void devcgroup_destroy(struct cgroup_subsys *ss,
>  #define DEVCG_DENY 2
>  #define DEVCG_LIST 3
> 
> -#define MAJMINLEN 10
> +#define MAJMINLEN 13
>  #define ACCLEN 4
> 
>  static void set_access(char *acc, short access)
> @@ -254,7 +254,7 @@ static void set_majmin(char *str, unsigned m)
>  	if (m == ~0)
>  		sprintf(str, "*");
>  	else
> -		snprintf(str, MAJMINLEN, "%d", m);
> +		snprintf(str, MAJMINLEN, "%u", m);
>  }
> 
>  static int devcgroup_seq_read(struct cgroup *cgroup, struct cftype *cft,
> -- 
> 1.5.4.rc3
