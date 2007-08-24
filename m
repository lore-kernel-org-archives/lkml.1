Return-Path: <linux-kernel-owner+w=401wt.eu-S1760570AbXHXPzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbXHXPzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 11:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbXHXPzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 11:55:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbXHXPzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 11:55:17 -0400
Subject: Re: [PATCH 14/30] net: Kill some unneeded allocation return value
	casts in libertas
From: Dan Williams <dcbw@redhat.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <2ac91f5f0eed967cf1709cfbe476b351e536c299.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
	 <2ac91f5f0eed967cf1709cfbe476b351e536c299.1187912217.git.jesper.juhl@gmail.com>
Content-Type: text/plain
Date: Fri, 24 Aug 2007 11:50:24 -0400
Message-Id: <1187970624.20110.0.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-24 at 02:03 +0200, Jesper Juhl wrote:
> kmalloc() and friends return void*, no need to cast it.

Applied to libertas-2.6 'for-linville' branch, thanks.

Dan

> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
>  drivers/net/wireless/libertas/debugfs.c |    2 +-
>  drivers/net/wireless/libertas/ethtool.c |    3 +--
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
> index 715cbda..6ade63e 100644
> --- a/drivers/net/wireless/libertas/debugfs.c
> +++ b/drivers/net/wireless/libertas/debugfs.c
> @@ -1839,7 +1839,7 @@ static ssize_t wlan_debugfs_write(struct file *f, const char __user *buf,
>  	char *p2;
>  	struct debug_data *d = (struct debug_data *)f->private_data;
>  
> -	pdata = (char *)kmalloc(cnt, GFP_KERNEL);
> +	pdata = kmalloc(cnt, GFP_KERNEL);
>  	if (pdata == NULL)
>  		return 0;
>  
> diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
> index 96f1974..7dad493 100644
> --- a/drivers/net/wireless/libertas/ethtool.c
> +++ b/drivers/net/wireless/libertas/ethtool.c
> @@ -60,8 +60,7 @@ static int libertas_ethtool_get_eeprom(struct net_device *dev,
>  
>  //      mutex_lock(&priv->mutex);
>  
> -	adapter->prdeeprom =
> -		    (char *)kmalloc(eeprom->len+sizeof(regctrl), GFP_KERNEL);
> +	adapter->prdeeprom = kmalloc(eeprom->len+sizeof(regctrl), GFP_KERNEL);
>  	if (!adapter->prdeeprom)
>  		return -ENOMEM;
>  	memcpy(adapter->prdeeprom, &regctrl, sizeof(regctrl));

