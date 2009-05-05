Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbZEEMse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbZEEMse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 08:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbZEEMsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 08:48:22 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:47071 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755495AbZEEMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 08:48:21 -0400
Message-ID: <4A003593.60001@rsk.demon.co.uk>
Date: Tue, 05 May 2009 13:48:19 +0100
From: Richard Kennedy <richard@rsk.demon.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: p80211wext.c: possible problem with IW_ENCODE_ALG_WEP
References: <Pine.LNX.4.64.0905051330150.9552@pc-004.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0905051330150.9552@pc-004.diku.dk>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> The file drivers/staging/wlan-ng/p80211wext.c contains the following code:
> 
> (starting at line 1490 in a recent linux-next)
> 
> 		if (!(ext->alg & IW_ENCODE_ALG_WEP)) {
> 			pr_debug("asked to set a non wep key :(");
> 			return -EINVAL;
> 		}
> 
> The reference to IW_ENCODE_ALG_WEP seems to refer to the following
> definitions in include/linux/wireless.h
> 
> /* struct iw_encode_ext ->alg */
> #define IW_ENCODE_ALG_NONE	0
> #define IW_ENCODE_ALG_WEP	1
> #define IW_ENCODE_ALG_TKIP	2
> #define IW_ENCODE_ALG_CCMP	3
> #define IW_ENCODE_ALG_PMK	4
> #define IW_ENCODE_ALG_AES_CMAC	5
> 
> But if the alg field returns true for a bit and with IW_ENCODE_ALG_WEP,
> then it would also return true for a bit and with IW_ENCODE_ALG_CCMP and
> IW_ENCODE_ALG_AES_CMAC.  Is this what is intended, or should the test be
> encoded in another way?
> 
> julia
Hi Julia,

You're quite right, this is not what was intended.

The card only handles WEP keys so
	if (ext->alg != IW_ENCODE_ALG_WEP)  {...}

would be better.

Do you want to send a patch to correct this? If not, I can do it.

regards
Richard
