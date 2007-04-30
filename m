Return-Path: <linux-kernel-owner+w=401wt.eu-S1423328AbXD3OvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423328AbXD3OvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423327AbXD3OvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:51:12 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:38845 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1423330AbXD3OvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:51:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VRBX9b3YDVxsf29AO/wu6Mwegd7AhTTSc2HPkqrPcxlIYqM3/T1BkfgDQmxPUZc7klzODHUmxVY/BhNSiQhDO39wHYiVJQQf0qdtM1pzHv5mVe+Fdb6T3D7ijl57pAV3QEWTjDLw9+D9ivA3YO9SMrJN/oy6GaDEYhfU9DEudUs=  ;
X-YMail-OSG: MMy1Yx0VM1m3buce03bV6zBgztgxPVCUqlj8w3iJriCs_Bv7zYKQLBuX403PuNwpoPUWj_RH1w--
From: David Brownell <david-b@pacbell.net>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch] pm: include EIO from errno-base.h
Date: Mon, 30 Apr 2007 07:51:06 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0704291700220.1822@chino.kir.corp.google.com>
In-Reply-To: <Pine.LNX.4.64.0704291700220.1822@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704300751.07078.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 April 2007, David Rientjes wrote:
> call_platform_enable_wakeup() uses EIO, so it needs to be defined.
> 
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Signed-off-by: David Rientjes <rientjes@google.com>

Actually, in that PM-is-disabled case returning zero (success)
rather than -EIO would have been the backwards-compatible
approach ... the hook not being there shouldn't be an error.
And returning zero wouldn't require this #include either...

- Dave


> ---
>  include/linux/pm.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/pm.h b/include/linux/pm.h
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -25,6 +25,7 @@
>  
>  #include <linux/list.h>
>  #include <asm/atomic.h>
> +#include <asm/errno.h>
>  
>  /*
>   * Power management requests... these are passed to pm_send_all() and friends.
> 


