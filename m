Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbYKLLdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbYKLLdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 06:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYKLLdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 06:33:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:12717 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbYKLLdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 06:33:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=EGWf75Me/FhDfnwCQl6SuH7ynUyxgqBoK88hWUxubvxS+sqJ0QHtAd47Pf0XZIUANn
         6JQpMk6vpx/kMT76J11+A7b1uiDBSnesCEqawiboMNVmXjGNVzloYjLMZhzdyXUbzBP7
         0C57/FW0Twq1j054Ga5xm85V+K7SprgMYnKxM=
Date: Wed, 12 Nov 2008 14:36:46 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] lockdep: silence warnings
Message-ID: <20081112113646.GA4629@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

net/bluetooth/af_bluetooth.c:57: warning: 'bt_key_strings' defined but not used
net/bluetooth/af_bluetooth.c:68: warning: 'bt_slock_key_strings' defined but not used

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/lockdep.h |    4 ++--
 net/core/sock.c         |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -331,10 +331,10 @@ static inline void lockdep_on(void)
 # define lock_set_subclass(l, s, i)		do { } while (0)
 # define lockdep_init()				do { } while (0)
 # define lockdep_info()				do { } while (0)
-# define lockdep_init_map(lock, name, key, sub)	do { (void)(key); } while (0)
+# define lockdep_init_map(lock, name, key, sub)	do { (void)(name); (void)(key); } while (0)
 # define lockdep_set_class(lock, key)		do { (void)(key); } while (0)
 # define lockdep_set_class_and_name(lock, key, name) \
-		do { (void)(key); } while (0)
+		do { (void)(key); (void)(name); } while (0)
 #define lockdep_set_class_and_subclass(lock, key, sub) \
 		do { (void)(key); } while (0)
 #define lockdep_set_subclass(lock, sub)		do { } while (0)
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -136,7 +136,6 @@
 static struct lock_class_key af_family_keys[AF_MAX];
 static struct lock_class_key af_family_slock_keys[AF_MAX];
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
 /*
  * Make lock validator output more readable. (we pre-construct these
  * strings build-time, so that runtime initialization of socket
@@ -187,7 +186,6 @@ static const char *af_family_clock_key_strings[AF_MAX+1] = {
   "clock-AF_RXRPC" , "clock-AF_ISDN"     , "clock-AF_PHONET"   ,
   "clock-AF_MAX"
 };
-#endif
 
 /*
  * sk_callback_lock locking rules are per-address-family,
