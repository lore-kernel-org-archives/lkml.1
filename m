Return-Path: <linux-kernel-owner+w=401wt.eu-S1764301AbXJOMDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764301AbXJOMDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 08:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758956AbXJOMDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 08:03:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:7264 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559AbXJOMDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 08:03:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=oxoZI7Pbyudvj4j4fNMy+72BV47Tcz9hcdQ+53znD94c8uQ6Mdl50br2KN9VMsAUIU+aOEPqbvE050pQxtsCLZGUaZ35wIHJoU+G/U2BNUL0x0gOaz2ccgyBaqSqqsUJYRfMzovZncyHXBUpiqTHKkl9br9mqLO6fa88miVUqY8=
Date: Mon, 15 Oct 2007 19:59:36 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: mb@bu3sch.de, st3@riseup.net, Larry.Finger@lwfinger.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: [-mm Patch] drivers/net/wireless/b43legacy/main.c: initialize the
	correct return value
Message-ID: <20071015115936.GP2444@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071014175142.GN4211@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071014175142.GN4211@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Initialize "err" in drivers/net/wireless/b43legacy/main.c::b43legacy_start()
in case of returning an uninitialized value.

From: Adrian Bunk <bunk@kernel.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 drivers/net/wireless/b43/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-mm1/drivers/net/wireless/b43legacy/main.c
===================================================================
--- linux-2.6.23-mm1.orig/drivers/net/wireless/b43legacy/main.c
+++ linux-2.6.23-mm1/drivers/net/wireless/b43legacy/main.c
@@ -3306,7 +3306,7 @@ static int b43legacy_start(struct ieee80
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
 	int did_init = 0;
-	int err;
+	int err = 0;
 
 	mutex_lock(&wl->mutex);
 
