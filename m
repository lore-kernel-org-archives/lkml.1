Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbXJNJgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbXJNJgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 05:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbXJNJgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 05:36:03 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:58721
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbXJNJgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 05:36:01 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] ssb: Fix regression in 2.6.23-git3 due to change in calling add_uevent_var
Date: Sun, 14 Oct 2007 11:35:17 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
       linux-wireless@vger.kernel.org
References: <47119f37.hwmEVx/qSP6GAYhm%Larry.Finger@lwfinger.net>
In-Reply-To: <47119f37.hwmEVx/qSP6GAYhm%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710141135.17798.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 October 2007 06:46:47 Larry Finger wrote:
> In commit 7eff2e7a8b65c25920207324e56611150eb1cd9a, the calling sequence
> for add_uevent_var was changed, but the ssb driver was not modified, which
> leads to a "Unable to handle kernel paging request" oops. This patch fixes
> the problem.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Acked-by: Michael Buesch <mb@bu3sch.de>

> ---
> 
>  drivers/ssb/main.c |   11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6/drivers/ssb/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/ssb/main.c
> +++ linux-2.6/drivers/ssb/main.c
> @@ -320,22 +320,17 @@ static int ssb_bus_match(struct device *
>  	return 0;
>  }
>  
> -static int ssb_device_uevent(struct device *dev, char **envp, int num_envp,
> -			     char *buffer, int buffer_size)
> +static int ssb_device_uevent(struct device *dev, struct kobj_uevent_env *env)
>  {
>  	struct ssb_device *ssb_dev = dev_to_ssb_dev(dev);
> -	int ret, i = 0, length = 0;
> +	int ret;
>  
>  	if (!dev)
>  		return -ENODEV;
>  
> -	ret = add_uevent_var(envp, num_envp, &i,
> -			     buffer, buffer_size, &length,
> -			     "MODALIAS=ssb:v%04Xid%04Xrev%02X",
> +	ret = add_uevent_var(env, "MODALIAS=ssb:v%04Xid%04Xrev%02X",
>  			     ssb_dev->id.vendor, ssb_dev->id.coreid,
>  			     ssb_dev->id.revision);
> -	envp[i] = NULL;
> -
>  	return ret;
>  }
>  
> 
> 



-- 
Greetings Michael.
