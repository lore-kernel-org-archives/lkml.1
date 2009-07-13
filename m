Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbZGMSHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbZGMSHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 14:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbZGMSHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 14:07:45 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57004 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051AbZGMSHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 14:07:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=eeSu2DtmGOaXUbNxz9v42uhj4/0p3Ag+xk78Ums+tNF8pon9dq+LSbxOoZEtLGuXaF
         1YX9KwGnBsR0iCVf35aLCz3hwmaXA16sB6CAQe8g9WAIeUV/R+vOPaJWc1C1ZDOdiOIi
         DDKTUctT93j3++SNbAoQ1uftCip6ReF6ez7v4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 13 Jul 2009 20:14:21 +0200
Message-Id: <20090713181421.16765.63615.sendpatchset@localhost.localdomain>
In-Reply-To: <20090713181329.16765.68428.sendpatchset@localhost.localdomain>
References: <20090713181329.16765.68428.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/10] Staging: rtl8192su/ieee80211: remove unused IEEE80211_PRINT_STR()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtl8192su/ieee80211: remove unused IEEE80211_PRINT_STR()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/ieee80211/ieee80211.h |   26 ------------------------
 1 file changed, 26 deletions(-)

Index: b/drivers/staging/rtl8192su/ieee80211/ieee80211.h
===================================================================
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211.h
@@ -472,32 +472,6 @@ do { if (ieee80211_debug_level & (level)
 #define IEEE80211_DEBUG_RX(f, a...)  IEEE80211_DEBUG(IEEE80211_DL_RX, f, ## a)
 #define IEEE80211_DEBUG_QOS(f, a...)  IEEE80211_DEBUG(IEEE80211_DL_QOS, f, ## a)
 
-#ifdef CONFIG_IEEE80211_DEBUG
-/* Added by Annie, 2005-11-22. */
-#define MAX_STR_LEN     64
-/* I want to see ASCII 33 to 126 only. Otherwise, I print '?'. Annie, 2005-11-22.*/
-#define PRINTABLE(_ch)  (_ch>'!' && _ch<'~')
-#define IEEE80211_PRINT_STR(_Comp, _TitleString, _Ptr, _Len)                            	\
-                        if((_Comp) & level)   							\
-                        {                                                                       \
-                                int             __i;                                            \
-                                u8  buffer[MAX_STR_LEN];                                    	\
-                                int length = (_Len<MAX_STR_LEN)? _Len : (MAX_STR_LEN-1) ;  	\
-                                memset(buffer, 0, MAX_STR_LEN);                      		\
-                                memcpy(buffer, (u8 *)_Ptr, length );            		\
-                                for( __i=0; __i<MAX_STR_LEN; __i++ )                            \
-                                {                                                               \
-                                     if( !PRINTABLE(buffer[__i]) )   buffer[__i] = '?';     	\
-                                }                                                               \
-                                buffer[length] = '\0';                                          \
-                                printk("Rtl819x: ");                                         	\
-                                printk(_TitleString);                                         \
-                                printk(": %d, <%s>\n", _Len, buffer);                         \
-                        }
-#else
-#define IEEE80211_PRINT_STR(_Comp, _TitleString, _Ptr, _Len)  do {} while (0)
-#endif
-
 #include <linux/netdevice.h>
 #include <linux/if_arp.h> /* ARPHRD_ETHER */
 
