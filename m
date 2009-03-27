Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbZC0QvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbZC0QvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 12:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757167AbZC0Qu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 12:50:58 -0400
Received: from gw.goop.org ([64.81.55.164]:51951 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757265AbZC0Qu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 12:50:57 -0400
Message-ID: <49CD03EE.2070003@goop.org>
Date: Fri, 27 Mar 2009 09:50:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Isaku Yamahata <yamahata@valinux.co.jp>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH] xen/balloon: remove a warning.
References: <20090327061438.GL13054%yamahata@valinux.co.jp>
In-Reply-To: <20090327061438.GL13054%yamahata@valinux.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isaku Yamahata wrote:
> This patch removes the following warning on ia64.
>
> drivers/xen/balloon.c: In function 'show_target':
> drivers/xen/balloon.c:516: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type 'long unsigned int'
>   

Ah, the old long vs long long u64 bites again.  OK.

    J

> Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
> ---
>  drivers/xen/balloon.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> index efa4b36..b989ba6 100644
> --- a/drivers/xen/balloon.c
> +++ b/drivers/xen/balloon.c
> @@ -513,7 +513,8 @@ static ssize_t show_target(struct sys_device *dev, struct sysdev_attribute *attr
>  			      char *buf)
>  {
>  	return sprintf(buf, "%llu\n",
> -		       (u64)balloon_stats.target_pages << PAGE_SHIFT);
> +		       (unsigned long long)balloon_stats.target_pages <<
> +		       PAGE_SHIFT);
>  }
>  
>  static ssize_t store_target(struct sys_device *dev,
>   

