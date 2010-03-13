Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516Ab0CMDIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 22:08:50 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:49555 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757618Ab0CMDIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 22:08:49 -0500
Subject: Re: Weird wireless/wpa_supplicant screw-up.
From: Johannes Berg <johannes@sipsolutions.net>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <5220.1268430568@localhost>
References: <7197.1268086939@localhost>
	 <1268392481.4828.7.camel@jlt3.sipsolutions.net> <5220.1268430568@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Mar 2010 19:09:09 -0800
Message-ID: <1268449749.4880.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-12 at 16:49 -0500, Valdis.Kletnieks@vt.edu wrote:

> OK, getting closer ;)

No ... you're not getting closer at all ... you ignored my second email.

> in net/wireless/wext-compat.c, we have this in cfg80211_wext_giwencode()
> after I add some printk's:
> 
> printk(KERN_INFO "In giwencode idx=%d keys=%x cipher=%x\n", idx, wdev->wext.keys, wdev->wext.keys->params[idx].cipher);
>         if (!wdev->wext.keys || !wdev->wext.keys->params[idx].cipher) {
> printk(KERN_INFO "And we're going home...\n");
>                 erq->flags |= IW_ENCODE_DISABLED;
>                 erq->length = 0;
>                 return 0;
>         }
> 
> which produces
> 
> [  151.401195] In giwencode idx=0 keys=1d023600 cipher=0
> [  151.401198] And we're going home...

No ... look at _all_ that it produces.

[   98.592575] In giwencode idx=0 keys=ffff88001b304000 cipher=0
[   98.592580] And we're going home...
*****
[   98.592633] In giwencode idx=1 keys=ffff88001b304000 cipher=fac04
*****
[   98.592749] In giwencode idx=2 keys=ffff88001b304000 cipher=0
[   98.592751] And we're going home...
[   98.592803] In giwencode idx=3 keys=ffff88001b304000 cipher=0
[   98.592805] And we're going home...
[   98.592856] In giwencode idx=0 keys=ffff88001b304000 cipher=0
[   98.592859] And we're going home...

See? It reports one key which is the RX-only group key which is
absolutely correct.

> So the root cause has something to do with params[idx].cipher being unset.

Not at all.

GIWENCODE is 100% unsuitable for WPA. Just forget about "iwlist key".
And then we'd like to know what the actual problem is.

johannes

