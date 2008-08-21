Return-Path: <linux-kernel-owner+w=401wt.eu-S1759726AbYHULpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759726AbYHULpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbYHULoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:44:55 -0400
Received: from smtp.nokia.com ([192.100.122.233]:53638 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759496AbYHULoy convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:44:54 -0400
Subject: Re: [PATCH 10/10] AXFS: axfs_uncompress.c
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: jaredeh@gmail.com
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, tim.bird@AM.SONY.COM,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <48AD0126.1050609@gmail.com>
References: <48AD0126.1050609@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 21 Aug 2008 14:40:38 +0300
Message-Id: <1219318838.18027.68.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 21 Aug 2008 11:42:17.0926 (UTC) FILETIME=[F6DFBE60:01C90382]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-20 at 22:46 -0700, Jared Hulbert wrote:
> +	err = zlib_inflateReset(&stream);
> +	if (err != Z_OK) {
> +		printk(KERN_ERR "zlib_inflateReset error %d\n", err);
> +		zlib_inflateEnd(&stream);
> +		zlib_inflateInit(&stream);
> +	}

Jared,

just FYI, are you aware that LZO which is also present in the kernel is
much faster on decompress than zlib, while its compression is only
slightly worse?

I do not remember the digits, but last time I tested UBIFS, LZO
decompression was about 3 times faster than zlib on OMAP3. This depends
on architecture, etc of course. This may matter a lot if one is fighting
for faster system boot-up. So you might consider supporting LZO as well.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

