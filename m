Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbZEELbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbZEELbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 07:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZEELa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 07:30:59 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:54351 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbZEELa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 07:30:58 -0400
Date: Tue, 5 May 2009 13:30:53 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: p80211wext.c: possible problem with IW_ENCODE_ALG_WEP
Message-ID: <Pine.LNX.4.64.0905051330150.9552@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file drivers/staging/wlan-ng/p80211wext.c contains the following code:

(starting at line 1490 in a recent linux-next)

		if (!(ext->alg & IW_ENCODE_ALG_WEP)) {
			pr_debug("asked to set a non wep key :(");
			return -EINVAL;
		}

The reference to IW_ENCODE_ALG_WEP seems to refer to the following
definitions in include/linux/wireless.h

/* struct iw_encode_ext ->alg */
#define IW_ENCODE_ALG_NONE	0
#define IW_ENCODE_ALG_WEP	1
#define IW_ENCODE_ALG_TKIP	2
#define IW_ENCODE_ALG_CCMP	3
#define IW_ENCODE_ALG_PMK	4
#define IW_ENCODE_ALG_AES_CMAC	5

But if the alg field returns true for a bit and with IW_ENCODE_ALG_WEP,
then it would also return true for a bit and with IW_ENCODE_ALG_CCMP and
IW_ENCODE_ALG_AES_CMAC.  Is this what is intended, or should the test be
encoded in another way?

julia
