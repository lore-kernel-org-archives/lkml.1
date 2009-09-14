Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbZINPpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbZINPpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbZINPpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:45:34 -0400
Received: from smtp.nokia.com ([192.100.105.134]:47829 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbZINPpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:45:33 -0400
Subject: Re: [RFC][PATCH] mm: write_cache_pages be more sequential
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Nick Piggin <npiggin@suse.de>
Cc: chris.mason@oracle.com, david@fromorbit.com,
       Andrew Morton <akpm@linux-foundation.org>,
       "Bityutskiy Artem (Nokia-M/Helsinki)" <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AA513AA.3010206@nokia.com>
References: <4AA513AA.3010206@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Sep 2009 18:44:47 +0300
Message-Id: <1252943087.3778.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 14 Sep 2009 15:44:52.0673 (UTC) FILETIME=[4CDEA310:01CA3552]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-07 at 17:07 +0300, Adrian Hunter wrote:
> From 6f3bb7c26936c45d810048f59c369e8d5a5623fc Mon Sep 17 00:00:00 2001
> From: Adrian Hunter <adrian.hunter@nokia.com>
> Date: Mon, 7 Sep 2009 10:49:11 +0300
> Subject: [PATCH] mm: write_cache_pages be more sequential
> 
> If a file is written to sequentially, then writeback
> should write the pages sequentially also.  However,
> that does not always happen.  For example:
> 
> 1) user writes pages 0, 1 and 2 but 2 is incomplete
> 2) write_cache_pages writes pages 0, 1 and 2 and sets
> writeback_index to 3
> 3) user finishes writing page 2 and writes pages 3 and 4
> 4) write_cache_pages writes pages 3 and 4, and then cycles
> back and writes page 2 again.
> 
> So the pages are written out in the order 0, 1, 2, 3 ,4 ,2
> instead of 0, 1, 2, 2, 3, 4.
> 
> This situation was noticed on UBIFS because it writes
> directly from writepage.  Hence if there is an unexpected
> power-loss, a file will end up with a hole even though
> the file was written sequentially by the user.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>

I wonder, who would merge this patch?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

