Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725Ab0AVQBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab0AVQBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636Ab0AVQAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 11:00:46 -0500
Received: from smtp.nokia.com ([192.100.122.230]:20415 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab0AVQAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 11:00:44 -0500
Subject: Re: [PATCH 3/4] MTD: blkdevs: make hotplug work
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1264174506.24012.21.camel@maxim-laptop>
References: <1264174316.24012.17.camel@maxim-laptop>
	 <1264174506.24012.21.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 17:59:34 +0200
Message-ID: <1264175974.4494.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Jan 2010 15:59:37.0464 (UTC) FILETIME=[E5F28780:01CA9B7B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 17:35 +0200, Maxim Levitsky wrote:
> >From 368127067f4d39ba89096e4a5cb3be2dee361bad Mon Sep 17 00:00:00 2001
> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Date: Fri, 22 Jan 2010 15:00:55 +0200
> Subject: [PATCH 3/4] MTD: blkdevs: make hotplug work
> 
> This changes the blkdev common module for translation layers
> to survive when underlying mtd device disappears.
> 
> To do so the following conceptual changes were made:
> 
> * disk queue and thread are now one per mtd device
>  This was it is easy to flush and destroy the queue
> 
> * the struct mtd_blktrans_dev will now be freed automaticly when last user
>  of the device quits.
>  All existing translation layers are adjusted
> 
> * ->open and release function of the translation layer will never be called
>  twise or more in the row.
>  This makes code simplier.
>  Also the ->release will be called just before mtd device disappears
>  This and above is the only visable changes on the outside.
> 
> Tested with mtdblock, ssfdc and my own sm_ftl on top of physicly hotplugable
> nand card.
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

I'll try to find some time to review this later - I'm really busy
lately. But please, split this huge patch on smaller pieces - this will
help the reviewers a lot.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

