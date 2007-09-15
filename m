Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbXIOQVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbXIOQVy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 12:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbXIOQVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 12:21:45 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:63390 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbXIOQVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 12:21:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a4gYSnpLCNBgKcvDGsOllrWChWTLxbeFpi8HVdEQd9rGiFy/W54mUtmNufPwM2U4Ratv6H9YXPXcbNYadwAKYfjbxRV4aMDhY/jV2T+9zVPeKAEFOYRfHLZj3nuaPFJvlL/+tzvLfPhwB0pkVnme1UjddRrfS92vD7+6NsPTCS4=
Message-ID: <6b8cef970709150921s48488096wa8089d8d9f5d28bf@mail.gmail.com>
Date: Sat, 15 Sep 2007 12:21:39 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: "=?ISO-2022-JP?B?GyRCJV0hPCVrISYlbSVpJXMbKEIgUGF1bCBSb2xsYW5k?=" 
	<rol@witbe.net>
Subject: Re: 2.6.23-rc6 : crash with RTL8187 USB
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070915131656.4cddab33@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070915131656.4cddab33@tux.DEF.witbe.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/07, ポール・ロラン Paul Rolland <rol@witbe.net> wrote:
> Hello,
>
> Each time I add the support for this piece of hardware, I have a crash during
> the boot process.
> Serial console gives the attached boot message...
>
...
> WARNING: at lib/kref.c:33 kref_get()
> Call Trace:
>  [<ffffffff8121fa41>] kref_get+0x2f/0x36
>  [<ffffffff8121ec3f>] kobject_get+0x12/0x17
>  [<ffffffff8121edad>] kobject_shadow_add+0x7f/0x1a2
>  [<ffffffff812beaa4>] device_add+0xb7/0x631
>  [<ffffffff81040607>] msleep+0x14/0x1e
>  [<ffffffff8149f95f>] wiphy_register+0x29/0x80
>  [<ffffffff814a4a9b>] ieee80211_register_hw+0x11/0x208
>  [<ffffffff812e1a64>] rtl8187_probe+0x544/0x624

I had this problem as well. It has to do with mac80211, cfg80211 and
the rate control algorithm not initializing early enough in the boot
process. These two patches should fix it:

[PATCH] mac80211: fix initialisation when built-in
http://article.gmane.org/gmane.linux.kernel.wireless.general/5710/match=patch+mac80211+initialisation

[PATCH] cfg80211: fix initialisation if built-in
http://article.gmane.org/gmane.linux.network/71326/match=patch+cfg80211+initialisation

Regards,
Rob
