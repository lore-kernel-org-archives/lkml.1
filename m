Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZLWKjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZLWKjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 05:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbZLWKji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 05:39:38 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:47500 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZLWKji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 05:39:38 -0500
Date: Wed, 23 Dec 2009 21:39:37 +1100
From: Simon Horman <horms@verge.net.au>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 7/7] [patch] =?utf-8?Q?rtl8192u?=
	=?utf-8?Q?=3A_Clarify_logic_in=E2=80=98ieee80211=5Fwx=5Fget=5Fencode=5Fex?=
	=?utf-8?B?dF9yc2woKQ==?=
Message-ID: <20091223103933.GA16537@verge.net.au>
References: <20091223085448.619253793@vergenet.net>
 <20091223085553.648368336@vergenet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091223085553.648368336@vergenet.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Simon Horman <horms@verge.net.au>

--- 

I think this is what is meant.

Compile tested only.

$ gcc --version
gcc (Debian 4.4.2-6) 4.4.2
Copyright (C) 2009 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ make CONFIG_DEBUG_SECTION_MISMATCH=y
...
drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c: In function ‘ieee80211_wx_get_encode_ext_rsl’:
drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c:721: warning: suggest parentheses around operand of ‘!’ or change ‘&’ to ‘&&’ or ‘!’ to ‘~’
...

[ Trying again as vger didn't like the headers the first time around ]

Index: gregkh-2.6/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
===================================================================
--- gregkh-2.6.orig/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c	2009-12-23 19:14:41.000000000 +1100
+++ gregkh-2.6/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c	2009-12-23 19:14:44.000000000 +1100
@@ -718,7 +718,7 @@ int ieee80211_wx_get_encode_ext(struct i
 	} else
 		idx = ieee->tx_keyidx;
 
-	if (!ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY &&
+	if (!(ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) &&
 	    ext->alg != IW_ENCODE_ALG_WEP)
 		if (idx != 0 || ieee->iw_mode != IW_MODE_INFRA)
 			return -EINVAL;

