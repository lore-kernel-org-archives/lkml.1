Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbXLBQnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbXLBQnm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 11:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbXLBQnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 11:43:33 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:14270 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbXLBQnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 11:43:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=plfTR5gI9QOQIBdorcawKMT+NSKkyMoGZcfgycd9W8tGHwR0Nz5vtHsXgAg6PNrrWLeu0dz90M7WetdKfAqbkYUwmwUaAmM4q3i+fRV7n8d+29TbiAj4xnGvxunhuF271AN7JMHOKUm1S0eengc+rV3yTd9YAvTFTPdSlxuHCnI=
Date: Sun, 2 Dec 2007 19:43:16 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Tuttle <linux-kernel@ttuttle.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Oops with 2.6.24 git when loading iwl3945
Message-ID: <20071202164316.GB7377@cvg>
References: <1196196237.19410.1223544787@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196196237.19410.1223544787@webmail.messagingengine.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Thomas Tuttle - Tue, Nov 27, 2007 at 03:43:57PM -0500]
| Hey.
| 
| I'm using a git snapshot that gentoo distributed mere hours ago (so I'm
| fairly confident it's current), and I'm getting an Oops when I try to
| load the iwl3945 driver.  I've attached it as plain text.
| 
| Hope this helps,
| 
| Thomas Tuttle

Hi Thomas,
Could you please test the patch?

		Cyrill
---

Seems just mutex unlock is missed ;)

 net/mac80211/ieee80211_rate.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_rate.c b/net/mac80211/ieee80211_rate.c
index 7254bd6..3260a4a 100644
--- a/net/mac80211/ieee80211_rate.c
+++ b/net/mac80211/ieee80211_rate.c
@@ -33,6 +33,7 @@ int ieee80211_rate_control_register(struct rate_control_ops *ops)
 		if (!strcmp(alg->ops->name, ops->name)) {
 			/* don't register an algorithm twice */
 			WARN_ON(1);
+			mutex_unlock(&rate_ctrl_mutex);
 			return -EALREADY;
 		}
 	}
