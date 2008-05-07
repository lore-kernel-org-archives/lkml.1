Return-Path: <linux-kernel-owner+w=401wt.eu-S1761986AbYEGGIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761986AbYEGGIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 02:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbYEGGIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 02:08:25 -0400
Received: from smtp.nokia.com ([192.100.105.134]:58235 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbYEGGIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 02:08:23 -0400
Message-ID: <4821470E.3010108@yandex.ru>
Date: Wed, 07 May 2008 09:07:10 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Kyungmin Park <kmpark@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [PATCH take 2 08/28] UBIFS: add superblock and master node
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com>	 <1210070159-22794-9-git-send-email-Artem.Bityutskiy@nokia.com> <9c9fda240805061648s75080531rd25db46d65022bf1@mail.gmail.com>
In-Reply-To: <9c9fda240805061648s75080531rd25db46d65022bf1@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 07 May 2008 06:07:17.0236 (UTC) FILETIME=[9A245B40:01C8B008]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kyungmin Park wrote:
> Here's one proposal. Please add the  no compressed mode support.
> In my simple test. it's working with  no compress mode.
> Yes I know, it makes the performance poor. but we can measure the
> metadata operation overhead compare to the previous flash filesystems.

We support "no compression" node already. You may do one of the following:

1. Disable compression support in configuration menu, in which case
"no compression" will be the only option.
2. When you create your file-system with mkfs.ubifs, use "--compr none",
in which case the default compression mode will be "none". But it does
not mean you will not be able to enable compression for certain files.
3. Use "chattr -c <file name>" (or IOC_SETFLAGS ioctl) to disable
compression for a specific file.

>>  +/* The default maximum size of reserved pool in bytes */
>>  +#define DEFAULT_MAX_RP_SIZE (5*1024*1024)
>>  +
>>  +/* Default UBIFS compressor */
>>  +#define DEFAULT_COMPRESSOR UBIFS_COMPR_LZO
>>  +
> 
> #ifdef CONFIG_UBIFS_FS_NO_COMPR
> #define DEFAULT_COMPRESSOR UBIFS_COMPR_NONE
> #else
> #define DEFAULT_COMPRESSOR UBIFS_COMPR_LZO
> #endif

DEFAULT_COMPRESSOR is just default compressor which is used
when UBIFS mounts an empty volume and formats it automatically.
You may use mkfs.ubifs instead and pre-format the volume, in which
case you may specify "none" compression method.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
