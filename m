Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988Ab0A0VQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab0A0VQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 16:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044Ab0A0VQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 16:16:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:44329 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab0A0VQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 16:16:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=PnuOnSWqhBpg56NxII39cb34Mc/qV/vgh3RjytPBYnMA+A72b8eFFixZ4r4yxTziFK
         Kt3nW5F4L1RPV6dqMQOhKqTYe0qaiOxqrkOF+2PuLsSta5ukbC2hGvmmbFnrVgLtq0zL
         a7ra0LlJHkGMm8OJGDaN64HAQ0Lon/ctLsgSw=
Message-ID: <4B60AD1C.7080603@gmail.com>
Date: Wed, 27 Jan 2010 22:16:12 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 11/13] drivers/block/floppy.c: Remove obfuscating CODE2SIZE
 macro
References: <cover.1264624291.git.joe@perches.com> <4cafcde7cd66be92f7d0bde18745cf0201c1edee.1264624292.git.joe@perches.com>
In-Reply-To: <4cafcde7cd66be92f7d0bde18745cf0201c1edee.1264624292.git.joe@perches.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 09:46 PM, Joe Perches wrote:
> @@ -2347,7 +2346,7 @@ static void rw_interrupt(void)
>  		DRS->first_read_date = jiffies;
>  
>  	nr_sectors = 0;
> -	CODE2SIZE;
> +	ssize = ((1 << SIZECODE) + 3) >> 2;

If you plan to post another series, you could further tune it up with:
DIV_ROUND_UP(1 << SIZECODE, 4);

-- 
js
