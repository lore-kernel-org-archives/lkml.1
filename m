Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbZBNWtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbZBNWtV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZBNWtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:49:05 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:35229 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbZBNWtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:49:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=GoLd2KKrTXEAFifhjx4mri/Bi1XgGRyTJDn42c9Jb2xbVOeh6bhN4HyW23/m+xXhxf
         5gDd1jASV9/Z7kdv81rtOIY/qfakY3mtBDe82COslVSdyt/SPhpjcXm3dMb12iZ/Jgit
         ghiUtOYEPSUBKchNR1Mz7q1RgvMk+efM61L3A=
Message-ID: <49974A5A.9030109@gmail.com>
Date: Sat, 14 Feb 2009 23:48:58 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Hannes Eder <hannes@hanneseder.net>
CC: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/isdn/hardware/mISDN: change type of hfc_jiffies
 to ulong
References: <20090214224049.28194.38982.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090214224049.28194.38982.stgit@vmbox.hanneseder.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Eder wrote:
> Patch suggested by Jiri Slaby.

Well, at least some log needed.

jiffies are ulong, make sure we fit in jiffies store variable on archs with
bits per long > 32.

> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
> 
> This patch is based on:
>     drivers/isdn/hardware/mISDN: fix sparse warnings: make symbols static
> 
>  drivers/isdn/hardware/mISDN/hfcpci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
> index 2bb85c4..c7a855c 100644
> --- a/drivers/isdn/hardware/mISDN/hfcpci.c
> +++ b/drivers/isdn/hardware/mISDN/hfcpci.c
> @@ -57,7 +57,7 @@ static int HFC_cnt;
>  static uint debug;
>  static uint poll, tics;
>  static struct timer_list hfc_tl;
> -static u32 hfc_jiffies;
> +static ulong hfc_jiffies;

Ok, unsigned long would be nicer. I though it would be implicit when writing
about ulong, but I see not in this uint-et-al context...
