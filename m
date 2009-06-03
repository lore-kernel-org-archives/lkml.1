Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbZFCXQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbZFCXQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 19:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZFCXPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 19:15:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:25727 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZFCXPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 19:15:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t+SQ1tOo/hCipfsABg/8pjmUKHxQpaBGCi4hnzECcD2wJIVwf0GjHoz8FZLs/ogEX3
         884Rzbl+T/XcOdE2ujILCUCszDyS2WqGCC3WgtnVL73etKp63/fO2pNHjeLdODAf7KnH
         nOJzUuX3lwlni22aPOYGDYu0S8I1d6atOaQAk=
Date: Thu, 4 Jun 2009 03:15:37 +0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, sfr@canb.auug.org.au,
       slapin@ossfans.org
Subject: Re: [PATCH 2/6] Add constants for the ieee 802.15.4/ZigBee stack
Message-ID: <20090603231537.GB32561@doriath.ww600.siemens.net>
References: <1244021629-18409-3-git-send-email-dbaryshkov@gmail.com> <20090603.030826.03512651.davem@davemloft.net> <20090603105151.GA20508@doriath.ww600.siemens.net> <20090603.141919.261921857.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603.141919.261921857.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 02:19:19PM -0700, David Miller wrote:
> From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Date: Wed, 3 Jun 2009 14:51:51 +0400
> 
> > Please check the updated patch. We do request several unused in this
> > serie value (like AF_ZIGBEE), but we'd like for them to be merged ASAP
> > as their are a part of ABI.
> 
> I don't allow anyone else to do this, and neither will I
> allow it for you either.

Sorry, we didn't know about this policy. No need to be that harsh!
Here is the cleaned up version.

>From d1e359b7f66a4acc8b41bbeaeeeee4c81501e4bc Mon Sep 17 00:00:00 2001
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Date: Thu, 4 Jun 2009 03:09:40 +0400
Subject: [PATCH 2/6] Add constants for the ieee 802.15.4/ZigBee stack

IEEE 802.15.4/ZigBee stack requires several constants to be defined/adjusted.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Sergey Lapin <slapin@ossfans.org>
---
 include/linux/if_arp.h   |    2 ++
 include/linux/if_ether.h |    1 +
 include/linux/socket.h   |    4 +++-
 net/core/dev.c           |    6 ++++--
 net/core/sock.c          |    3 +++
 5 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/if_arp.h b/include/linux/if_arp.h
index 5ff8980..b554300 100644
--- a/include/linux/if_arp.h
+++ b/include/linux/if_arp.h
@@ -86,6 +86,8 @@
 #define ARPHRD_IEEE80211 801		/* IEEE 802.11			*/
 #define ARPHRD_IEEE80211_PRISM 802	/* IEEE 802.11 + Prism2 header  */
 #define ARPHRD_IEEE80211_RADIOTAP 803	/* IEEE 802.11 + radiotap header */
+#define ARPHRD_IEEE802154	  804
+#define ARPHRD_IEEE802154_PHY	  805
 
 #define ARPHRD_PHONET	820		/* PhoNet media type		*/
 #define ARPHRD_PHONET_PIPE 821		/* PhoNet pipe header		*/
diff --git a/include/linux/if_ether.h b/include/linux/if_ether.h
index cfe4fe1..11a60e4 100644
--- a/include/linux/if_ether.h
+++ b/include/linux/if_ether.h
@@ -106,6 +106,7 @@
 #define ETH_P_DSA	0x001B		/* Distributed Switch Arch.	*/
 #define ETH_P_TRAILER	0x001C		/* Trailer switch tagging	*/
 #define ETH_P_PHONET	0x00F5		/* Nokia Phonet frames          */
+#define ETH_P_IEEE802154 0x00F6		/* IEEE802.15.4 frame		*/
 
 /*
  *	This is an Ethernet frame header.
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 421afb4..642d1f1 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -194,7 +194,8 @@ struct ucred {
 #define AF_RXRPC	33	/* RxRPC sockets 		*/
 #define AF_ISDN		34	/* mISDN sockets 		*/
 #define AF_PHONET	35	/* Phonet sockets		*/
-#define AF_MAX		36	/* For now.. */
+#define AF_IEEE802154	36	/* IEEE802154 sockets		*/
+#define AF_MAX		37	/* For now.. */
 
 /* Protocol families, same as address families. */
 #define PF_UNSPEC	AF_UNSPEC
@@ -233,6 +234,7 @@ struct ucred {
 #define PF_RXRPC	AF_RXRPC
 #define PF_ISDN		AF_ISDN
 #define PF_PHONET	AF_PHONET
+#define PF_IEEE802154	AF_IEEE802154
 #define PF_MAX		AF_MAX
 
 /* Maximum queue length specifiable by listen.  */
diff --git a/net/core/dev.c b/net/core/dev.c
index e2e9e4a..4119dfc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -268,7 +268,8 @@ static const unsigned short netdev_lock_type[] =
 	 ARPHRD_IRDA, ARPHRD_FCPP, ARPHRD_FCAL, ARPHRD_FCPL,
 	 ARPHRD_FCFABRIC, ARPHRD_IEEE802_TR, ARPHRD_IEEE80211,
 	 ARPHRD_IEEE80211_PRISM, ARPHRD_IEEE80211_RADIOTAP, ARPHRD_PHONET,
-	 ARPHRD_PHONET_PIPE, ARPHRD_VOID, ARPHRD_NONE};
+	 ARPHRD_PHONET_PIPE, ARPHRD_IEEE802154, ARPHRD_IEEE802154_PHY,
+	 ARPHRD_VOID, ARPHRD_NONE};
 
 static const char *netdev_lock_name[] =
 	{"_xmit_NETROM", "_xmit_ETHER", "_xmit_EETHER", "_xmit_AX25",
@@ -285,7 +286,8 @@ static const char *netdev_lock_name[] =
 	 "_xmit_IRDA", "_xmit_FCPP", "_xmit_FCAL", "_xmit_FCPL",
 	 "_xmit_FCFABRIC", "_xmit_IEEE802_TR", "_xmit_IEEE80211",
 	 "_xmit_IEEE80211_PRISM", "_xmit_IEEE80211_RADIOTAP", "_xmit_PHONET",
-	 "_xmit_PHONET_PIPE", "_xmit_VOID", "_xmit_NONE"};
+	 "_xmit_PHONET_PIPE", "_xmit_IEEE802154", "_xmit_IEEE802154_PHY",
+	 "_xmit_VOID", "_xmit_NONE"};
 
 static struct lock_class_key netdev_xmit_lock_key[ARRAY_SIZE(netdev_lock_type)];
 static struct lock_class_key netdev_addr_lock_key[ARRAY_SIZE(netdev_lock_type)];
diff --git a/net/core/sock.c b/net/core/sock.c
index 7dbf3ff..8a1644c 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -155,6 +155,7 @@ static const char *af_family_key_strings[AF_MAX+1] = {
   "sk_lock-27"       , "sk_lock-28"          , "sk_lock-AF_CAN"      ,
   "sk_lock-AF_TIPC"  , "sk_lock-AF_BLUETOOTH", "sk_lock-IUCV"        ,
   "sk_lock-AF_RXRPC" , "sk_lock-AF_ISDN"     , "sk_lock-AF_PHONET"   ,
+  "sk_lock-AF_IEEE802154",
   "sk_lock-AF_MAX"
 };
 static const char *af_family_slock_key_strings[AF_MAX+1] = {
@@ -170,6 +171,7 @@ static const char *af_family_slock_key_strings[AF_MAX+1] = {
   "slock-27"       , "slock-28"          , "slock-AF_CAN"      ,
   "slock-AF_TIPC"  , "slock-AF_BLUETOOTH", "slock-AF_IUCV"     ,
   "slock-AF_RXRPC" , "slock-AF_ISDN"     , "slock-AF_PHONET"   ,
+  "slock-AF_IEEE802154",
   "slock-AF_MAX"
 };
 static const char *af_family_clock_key_strings[AF_MAX+1] = {
@@ -185,6 +187,7 @@ static const char *af_family_clock_key_strings[AF_MAX+1] = {
   "clock-27"       , "clock-28"          , "clock-AF_CAN"      ,
   "clock-AF_TIPC"  , "clock-AF_BLUETOOTH", "clock-AF_IUCV"     ,
   "clock-AF_RXRPC" , "clock-AF_ISDN"     , "clock-AF_PHONET"   ,
+  "clock-AF_IEEE802154",
   "clock-AF_MAX"
 };
 
-- 
1.6.3.1

-- 
With best wishes
Dmitry

