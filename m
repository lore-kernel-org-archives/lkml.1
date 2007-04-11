Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbXDKPzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbXDKPzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 11:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbXDKPzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 11:55:11 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46890 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbXDKPzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 11:55:09 -0400
Message-ID: <461D04DB.80001@garzik.org>
Date: Wed, 11 Apr 2007 11:55:07 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: divy@chelsio.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.21 1/3] cxgb3 - avoid deadlock with mac watchdog
References: <20070410031022.12878.81342.stgit@localhost.localdomain>
In-Reply-To: <20070410031022.12878.81342.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

divy@chelsio.com wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> Fix a deadlock when the interface s configured down and 
> the watchdog tack is sleeping on rtnl_lock.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/net/cxgb3/cxgb3_main.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
> index 26240fd..c6ebe25 100644
> --- a/drivers/net/cxgb3/cxgb3_main.c
> +++ b/drivers/net/cxgb3/cxgb3_main.c
> @@ -2119,7 +2119,9 @@ static void check_t3b2_mac(struct adapte
>  {
>  	int i;
>  
> -	rtnl_lock();                      /* synchronize with ifdown */
> +	if (!rtnl_trylock())	/* synchronize with ifdown */
> +		return;
> +
>  	for_each_port(adapter, i) {
>  		struct net_device *dev = adapter->port[i];
>  		struct port_info *p = netdev_priv(dev);


applied 1-3


