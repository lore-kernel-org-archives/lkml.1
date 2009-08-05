Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622AbZHEPT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbZHEPT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 11:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZHEPT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 11:19:56 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:24944 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbZHEPTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 11:19:55 -0400
Date: Wed, 5 Aug 2009 08:19:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-08-04-14-22 uploaded (ummunotify)
Message-Id: <20090805081931.cf930271.randy.dunlap@oracle.com>
In-Reply-To: <adabpmulvdp.fsf@cisco.com>
References: <200908042125.n74LP9qY018119@imap1.linux-foundation.org>
	<20090804155014.35d4597c.randy.dunlap@oracle.com>
	<adabpmulvdp.fsf@cisco.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4A79A2FE.0129:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Aug 2009 21:47:30 -0700 Roland Dreier wrote:

> Andrew, can you add this into the ummunotify patch, or add it on top or whatever?
> 
> Fix
> 
>     ummunotify.c:(.text+0x8f217): undefined reference to `__get_user_X'
> 
> when building for i386 -- get_user() can't handle u64 on all
> architectures, so just use copy_from_user().
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Roland Dreier <rolandd@cisco.com>

Ack & thanks.


> ---
>  drivers/char/ummunotify.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/ummunotify.c b/drivers/char/ummunotify.c
> index 725fbb0..29de6ab 100644
> --- a/drivers/char/ummunotify.c
> +++ b/drivers/char/ummunotify.c
> @@ -453,7 +453,7 @@ static long ummunotify_unregister_region(struct ummunotify_file *priv,
>  	struct ummunotify_reg *reg;
>  	int ret = -EINVAL;
>  
> -	if (get_user(user_cookie, arg))
> +	if (copy_from_user(&user_cookie, arg, sizeof user_cookie))
>  		return -EFAULT;
>  
>  	spin_lock_irq(&priv->lock);
> --

---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
