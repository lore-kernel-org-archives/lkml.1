Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbZIMTFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbZIMTFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 15:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZIMTFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 15:05:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:34525 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754452AbZIMTFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 15:05:17 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+AhNxtWqSAoKxdUwo3av78W+8dQpUa0l9xkKggh+
	psYRfbDkedJW1R
Message-ID: <4AAD425A.8010605@gmx.de>
Date: Sun, 13 Sep 2009 21:04:58 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn
Subject: Re: [PATCH 3/3] viafb: use read-only mode parsing
References: <1252290284-3668-1-git-send-email-FlorianSchandinat@gmx.de>	<1252290284-3668-2-git-send-email-FlorianSchandinat@gmx.de>	<1252290284-3668-3-git-send-email-FlorianSchandinat@gmx.de> <20090909133956.c682bf4a.akpm@linux-foundation.org>
In-Reply-To: <20090909133956.c682bf4a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton schrieb:
> On Mon,  7 Sep 2009 02:24:44 +0000
> Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> 
>> +static void parse_mode(const char *str, u32 *xres, u32 *yres)
>> +{
>> +	char *ptr;
>> +
>> +	*xres = simple_strtoul(str, &ptr, 10);
>> +	if (ptr[0] != 'x')
>> +		goto out_default;
>> +
>> +	*yres = simple_strtoul(&ptr[1], &ptr, 10);
>> +	if (ptr[0])
>> +		goto out_default;
>> +
>> +	return;
>> +
>> +out_default:
>> +	printk(KERN_WARNING "viafb received invalid mode string: %s\n", str);
>> +	*xres = 640;
>> +	*yres = 480;
>> +}
> 
> One wonders if we could use sscanf here?

You're right.
But I am planning to add the optional arguments -<bpp> and @<refresh> to 
make it easier to select a mode and slowly move towards generic modedb 
format. I think that can be done easier with pointer handling than 
sscanf usage but I don't have a strong opinion about it so feel free to 
request me to change it.

Example: (new format)
viafb_mode=800x480-16@60
instead (old format)
viafb_mode=800x480 viafb_bpp=16 viafb_refresh=60

> The second simple_strtoul() could use strict_strtoul(), but that's not
> obviously superior IMO.

True.


Thanks,

Florian Tobias Schandinat
