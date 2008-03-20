Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbYCTH54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbYCTH54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 03:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYCTH5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 03:57:47 -0400
Received: from sacred.ru ([62.205.161.221]:39586 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbYCTH5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 03:57:46 -0400
Message-ID: <47E218AF.2030402@openvz.org>
Date: Thu, 20 Mar 2008 10:56:31 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andre Noll <maan@systemlinux.org>, "David S. Miller" <davem@davemloft.net>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Thery <benjamin.thery@bull.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Fix permissions of /proc/net
References: <20080319115135.GM32242@skl-net.de>
In-Reply-To: <20080319115135.GM32242@skl-net.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 20 Mar 2008 10:56:27 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andre Noll wrote:
> commit f205a545ee62e0f0f797c1e2b0bd2062d96414b3
> Author: Andre Noll <maan@congo.fml.local>
> Date:   Wed Mar 19 11:39:55 2008 +0100
> 
> From: Andre Noll <maan@systemlinux.org>
> 
> commit e9720ac ([NET]: Make /proc/net a symlink on /proc/self/net (v3))
> broke ganglia and probably other applications that read /proc/net/dev.

This also broke the postfix, as it was reported in bug #10286
and described in detail by Benjamin.

> This is due to the change of permissions of /proc/net that was
> introduced in that commit.
> 
> Before: dr-xr-xr-x 5 root root 0 Mar 19 11:30 /proc/net
> After: dr-xr--r-- 5 root root 0 Mar 19 11:29 /proc/self/net
> 
> This patch restores the permissions to the old value which makes ganglia
> happy again.

And it fixes the problem reported by Benjamin.
Thanks, Andre!

> Signed-off-by: Andre Noll <maan@systemlinux.org>

Acked-by: Pavel Emelyanov <xemul@openvz.org>
 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 8a10f6f..81d7d14 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2290,7 +2290,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  	DIR("fd",         S_IRUSR|S_IXUSR, fd),
>  	DIR("fdinfo",     S_IRUSR|S_IXUSR, fdinfo),
>  #ifdef CONFIG_NET
> -	DIR("net",        S_IRUGO|S_IXUSR, net),
> +	DIR("net",        S_IRUGO|S_IXUGO, net),
>  #endif
>  	REG("environ",    S_IRUSR, environ),
>  	INF("auxv",       S_IRUSR, pid_auxv),

