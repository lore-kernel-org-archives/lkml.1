Return-Path: <linux-kernel-owner+w=401wt.eu-S1763993AbXHDJQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763993AbXHDJQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 05:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758412AbXHDJQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 05:16:40 -0400
Received: from smtp.nokia.com ([131.228.20.171]:16437 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbXHDJQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 05:16:39 -0400
Subject: Re: [PATCH] UBI: Don't use signed int as array index before
	testing if it is negative
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200708040125.26861.jesper.juhl@gmail.com>
References: <200708040125.26861.jesper.juhl@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Sat, 04 Aug 2007 12:16:22 +0300
Message-Id: <1186218982.26902.47.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 04 Aug 2007 09:16:22.0928 (UTC) FILETIME=[2046D100:01C7D678]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-04 at 01:25 +0200, Jesper Juhl wrote:
> Hi,
> 
> I can't find anything guaranteeing that 'ubi_num' cannot be <0 in 
> drivers/mtd/ubi/kapi.c::ubi_open_volume(), and in fact the code 
> even tests for that and errors out if so. Unfortunately the test 
> for "ubi_num < 0" happens after we've already used 'ubi_num' as 
> an array index - bad thing to do if it is negative.
> This patch moves the test earlier in the function and then moves 
> the indexing using that variable after the check. A bit safer :-) 
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Thanks for the catch, committed to UBI git tree.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

