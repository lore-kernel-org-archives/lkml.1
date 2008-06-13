Return-Path: <linux-kernel-owner+w=401wt.eu-S1761464AbYFMQma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464AbYFMQma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 12:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758419AbYFMQmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 12:42:19 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:22690 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758200AbYFMQmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 12:42:18 -0400
Date: Fri, 13 Jun 2008 09:38:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       davem@daveloft.org
Subject: Re: [PATCH] [UPDATED] ixgbe: add LRO support
Message-Id: <20080613093835.4b092360.randy.dunlap@oracle.com>
In-Reply-To: <20080613162643.27996.32104.stgit@localhost.localdomain>
References: <20080613162643.27996.32104.stgit@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008 09:30:29 -0700 Jeff Kirsher wrote:

> From: Mallikarjuna R Chilakala <mallikarjuna.chilakala@intel.com>
> 
> Support for in-kernel LRO with the ability to enable/disable via ethtool
> based on comments from Ben Hutchings and Randy Dunlap.
> 
> 
> Signed-off-by: Mallikarjuna R Chilakala <mallikarjuna.chilakala@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Signed-off-by: PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>
> ---
> 
>  drivers/net/Kconfig               |    1 
>  drivers/net/ixgbe/ixgbe.h         |    9 +++
>  drivers/net/ixgbe/ixgbe_ethtool.c |   11 ++++
>  drivers/net/ixgbe/ixgbe_main.c    |  111 ++++++++++++++++++++++++++++++-------
>  4 files changed, 111 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index af46341..f6a15ed 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -2451,6 +2451,7 @@ config EHEA
>  config IXGBE
>  	tristate "Intel(R) 10GbE PCI Express adapters support"
>  	depends on PCI

+	depends on PCI && INET

> +	select INET_LRO

If INET is not enabled, selecting INET_LRO still won't enable INET and
build errors will result.  See the other drivers that select INET_LRO...


>  	---help---
>  	  This driver supports Intel(R) 10GbE PCI Express family of
>  	  adapters.  For more information on how to identify your adapter, go


---
~Randy
'"Daemon' is an old piece of jargon from the UNIX operating system,
where it referred to a piece of low-level utility software, a
fundamental part of the operating system."
