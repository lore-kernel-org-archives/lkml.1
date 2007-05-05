Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbXEEI30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbXEEI30 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 04:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbXEEI3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 04:29:25 -0400
Received: from smtp.nokia.com ([131.228.20.172]:65159 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbXEEI3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 04:29:24 -0400
X-Greylist: delayed 2039 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 May 2007 04:29:24 EDT
Subject: Re: [PATCH] UBI: dereference after kfree in create_vtbl
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Florin Malita <fmalita@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-mtd@lists.infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <a781481a0705042055u5e9ba060w95da83b0fbeff76a@mail.gmail.com>
References: <463A04A5.5030103@gmail.com>
	 <a781481a0705041442h37453fb6k26d04eb5356e9dc0@mail.gmail.com>
	 <463BC019.40305@gmail.com>
	 <a781481a0705042055u5e9ba060w95da83b0fbeff76a@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Sat, 05 May 2007 10:55:11 +0300
Message-Id: <1178351711.3659.54.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 05 May 2007 07:55:11.0574 (UTC) FILETIME=[B521EF60:01C78EEA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thanks for finding bugs in this patch. Although this path will likely
never happen, this is good to have it bug-free.

On Sat, 2007-05-05 at 09:25 +0530, Satyam Sharma wrote:
> Artem would have to step in here to verify if there really is a good
> reason why we kmalloc a fresh ubi_scan_leb every time we want to add
> one to a list. 
Particularly in vtbl.c there is no good reason. Leftover of itsy-bitsy
units. I'll make ubi_scan_add_to_list static, as well as
ubi_scan_add_used(). And I'll rename them to something shorter. They are
only useful in scan.c.

And it is fine to use list_add_tail() directly in vtbl.c. Will be fixed.

> If possible, the best solution would be to change
> ubi_scan_add_to_list() to take in a valid struct ubi_scan_leb and just
> add that to the specified list (using list_add_tail or whatever) --
> and leave allocation up to callers, 
In scan.c it is useful because _all_ callers have to allocate it. vtbl.c
is the only place which does not need it. I'll fix this.

> >though this likely requires a
> major cleanup of this driver w.r.t. ubi_scan_leb lifetime semantics.
What is wrong with the semantics, please be more specific.

I'll fix this shortly.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

