Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318Ab0ACPYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab0ACPYN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 10:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385Ab0ACPYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 10:24:10 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:52734 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab0ACPYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 10:24:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=soe4m+t+Q2WNT/iaHjW+AErOzL1z4JFabXVse3/8yGTMNe6KD+0QPrEPo2vmM6Fp8b
         u1GKGP4EfY6V412/4g/0UJGlch7uO0iXJ0T0J9zwCmPXwU0RYUAqyew00MAPXBNpWZvS
         Rec8j0dbYwUCuceSlfXAn+QHS8ecJ+L/flgDw=
Date: Sun, 3 Jan 2010 17:23:49 +0200
From: Dan Carpenter <error27@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [patch] precedence bug in ieee80211_wx_get_encode_ext()
Message-ID: <20100103152349.GA29327@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original test is always false because ! has precendence over &.

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c	2010-01-03 17:13:32.000000000 +0200
+++ devel/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c	2010-01-03 17:15:15.000000000 +0200
@@ -718,7 +718,7 @@ int ieee80211_wx_get_encode_ext(struct i
 	} else
 		idx = ieee->tx_keyidx;
 
-	if (!ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY &&
+	if (!(ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) &&
 	    ext->alg != IW_ENCODE_ALG_WEP)
 		if (idx != 0 || ieee->iw_mode != IW_MODE_INFRA)
 			return -EINVAL;
