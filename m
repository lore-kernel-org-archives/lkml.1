Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090AbYDEOFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbYDEOFy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 10:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYDEOFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 10:05:45 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:59844 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbYDEOFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 10:05:45 -0400
Message-ID: <47F78737.4050705@free.fr>
Date: Sat, 05 Apr 2008 16:05:43 +0200
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080313 Iceape/1.1.9 (Debian-1.1.9-1)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Michael Trimarchi <trimarchimichael@yahoo.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Josh Boyer <jwboyer@gmail.com>
Subject: Re: [PATCH] jffs2 summary allocation
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think the main problem is that mtd buffers are not dma compatible [1].
They can be allocated by vmalloc, don't be aligned on a page, ...

The problem was catch on jffs2 summary, but the same things could happen 
in other places.

So for me the correct fix, is either to fix mtd to have all buffer dma 
compatible or either fix mtd_dataflash to don't pass mtd buffer to spi 
stack, but to allocate dma buffer and do some copy.

BTW aren't there sparse annotation to track dma buffer ?

Matthieu

[1] http://article.gmane.org/gmane.linux.drivers.mtd/20663
As for the original question... I'm not sure. At the moment I don't
believe it's true that all such buffers are suitable for DMA. Perhaps it
would be sensible for us to redefine the MTD API so that it is required
(and fix the users).

