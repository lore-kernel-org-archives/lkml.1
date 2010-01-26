Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020Ab0AZTRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab0AZTRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993Ab0AZTRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:17:41 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50404 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab0AZTRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:17:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IYQT4zVfdLgqfyOyX9bqnROdsJ0Qz7wf7MskL7OTzfdRaZwKBMS1RmzsuY0JHRQVUS
         2e6R0LcFP+aKqJ97VR1QUt8hP0v/voQm0C6yyK/rAk1PCzwsfM3DaNBvl71UF5eWENrd
         0MlHuxO4yF6Qn4edN/9i+NMM4poOAamwhlqhY=
Date: Tue, 26 Jan 2010 21:17:27 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: geert@linux-m68k.org, linux-next@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] netdev: remove HAVE_ leftovers
Message-ID: <20100126191727.GA5454@x200>
References: <10f740e81001260057h37f3494dvefa3a37b2e1453a5@mail.gmail.com>
 <20100126.051817.215651254.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100126.051817.215651254.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 05:18:17AM -0800, David Miller wrote:
> Alexey, please go through at least drivers/net and look at the
> other stale references to these HAVE_* macros.

My apologies.


[PATCH] netdev: remove HAVE_ leftovers

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/net/cassini.c                  |    2 +-
 drivers/net/meth.c                     |    3 ---
 drivers/staging/wlags49_h2/wl_netdev.c |    6 ------
 3 files changed, 1 insertion(+), 10 deletions(-)

--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -106,7 +106,7 @@
 #define cas_page_unmap(x)    kunmap_atomic((x), KM_SKB_DATA_SOFTIRQ)
 #define CAS_NCPUS            num_online_cpus()
 
-#if defined(CONFIG_CASSINI_NAPI) && defined(HAVE_NETDEV_POLL)
+#ifdef CONFIG_CASSINI_NAPI
 #define USE_NAPI
 #define cas_skb_release(x)  netif_receive_skb(x)
 #else
--- a/drivers/net/meth.c
+++ b/drivers/net/meth.c
@@ -51,14 +51,11 @@
 
 static const char *meth_str="SGI O2 Fast Ethernet";
 
-#define HAVE_TX_TIMEOUT
 /* The maximum time waited (in jiffies) before assuming a Tx failed. (400ms) */
 #define TX_TIMEOUT (400*HZ/1000)
 
-#ifdef HAVE_TX_TIMEOUT
 static int timeout = TX_TIMEOUT;
 module_param(timeout, int, 0);
-#endif
 
 /*
  * This structure is private to each device. It is used to pass
--- a/drivers/staging/wlags49_h2/wl_netdev.c
+++ b/drivers/staging/wlags49_h2/wl_netdev.c
@@ -1194,9 +1194,7 @@ static const struct net_device_ops wl_netdev_ops =
     .ndo_stop               = &wl_adapter_close,
     .ndo_do_ioctl           = &wl_ioctl,
 
-#ifdef HAVE_TX_TIMEOUT
     .ndo_tx_timeout         = &wl_tx_timeout,
-#endif
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
     .ndo_poll_controller    = wl_poll,
@@ -1270,9 +1268,7 @@ struct net_device * wl_device_alloc( void )
     dev->stop               = &wl_adapter_close;
     dev->do_ioctl           = &wl_ioctl;
 
-#ifdef HAVE_TX_TIMEOUT
     dev->tx_timeout         = &wl_tx_timeout;
-#endif
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
     dev->poll_controller = wl_poll;
@@ -1280,9 +1276,7 @@ struct net_device * wl_device_alloc( void )
 
 #endif // (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
 
-#ifdef HAVE_TX_TIMEOUT
     dev->watchdog_timeo     = TX_TIMEOUT;
-#endif
 
     dev->ethtool_ops	    = &wl_ethtool_ops;
 
