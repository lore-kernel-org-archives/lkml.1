Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbZG1TYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbZG1TYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbZG1TYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:24:19 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:48862 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbZG1TYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:24:18 -0400
Date: Tue, 28 Jul 2009 12:23:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dhananjay Phadke <dhananjay@netxen.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH NEXT] netxen: fix CONFIG_INET=n build
Message-Id: <20090728122352.6d4a2b05.randy.dunlap@oracle.com>
In-Reply-To: <1248808203-9578-1-git-send-email-dhananjay@netxen.com>
References: <1248808203-9578-1-git-send-email-dhananjay@netxen.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4A6F505D.0116:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009 12:10:03 -0700 Dhananjay Phadke wrote:

> Wrap dest IP hashing code with #ifdef CONFIG_INET,
> this feature makes no sense without INET, but other
> driver can still work.
> 
> Signed-off-by: Dhananjay Phadke <dhananjay@netxen.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  drivers/net/netxen/netxen_nic_main.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
> index 2bbefa6..40549a0 100644
> --- a/drivers/net/netxen/netxen_nic_main.c
> +++ b/drivers/net/netxen/netxen_nic_main.c
> @@ -1875,6 +1875,8 @@ static void netxen_nic_poll_controller(struct net_device *netdev)
>  }
>  #endif
>  
> +#ifdef CONFIG_INET
> +
>  #define is_netxen_netdev(dev) (dev->netdev_ops == &netxen_netdev_ops)
>  
>  static int
> @@ -1993,6 +1995,7 @@ static struct notifier_block	netxen_netdev_cb = {
>  static struct notifier_block netxen_inetaddr_cb = {
>  	.notifier_call = netxen_inetaddr_event,
>  };
> +#endif
>  
>  static struct pci_driver netxen_driver = {
>  	.name = netxen_nic_driver_name,
> @@ -2012,8 +2015,10 @@ static int __init netxen_init_module(void)
>  	if ((netxen_workq = create_singlethread_workqueue("netxen")) == NULL)
>  		return -ENOMEM;
>  
> +#ifdef CONFIG_INET
>  	register_netdevice_notifier(&netxen_netdev_cb);
>  	register_inetaddr_notifier(&netxen_inetaddr_cb);
> +#endif
>  
>  	return pci_register_driver(&netxen_driver);
>  }
> @@ -2024,8 +2029,10 @@ static void __exit netxen_exit_module(void)
>  {
>  	pci_unregister_driver(&netxen_driver);
>  
> +#ifdef CONFIG_INET
>  	unregister_inetaddr_notifier(&netxen_inetaddr_cb);
>  	unregister_netdevice_notifier(&netxen_netdev_cb);
> +#endif
>  	destroy_workqueue(netxen_workq);
>  }
>  
> -- 
> 1.6.0.2
> 


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
