Return-Path: <linux-kernel-owner+w=401wt.eu-S1030762AbXDWELu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030762AbXDWELu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 00:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030776AbXDWELu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 00:11:50 -0400
Received: from lon-del-01.spheriq.net ([195.46.50.97]:39566 "EHLO
	lon-del-01.spheriq.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030762AbXDWELt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 00:11:49 -0400
From: Bhuvan Kumar MITTAL <bhuvan.mittal@st.com>
To: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: How to make mmap'ed kernel buffer non-cacheable
Date: Mon, 23 Apr 2007 09:41:20 +0530
Message-ID: <008e01c7855d$7af41de0$142ec70a@dlh.st.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20070420144312.74ec1ebd@the-village.bc.nu>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2962
Thread-Index: AceDUbs44PYA4IcAQgG51oMey+0+iACCmHgw
X-O-Spoofed: Not Scanned
X-O-General-Status: No
X-O-Spam1-Status: Not Scanned
X-O-Spam2-Status: Not Scanned
X-O-URL-Status: Not Scanned
X-O-Virus1-Status: No
X-O-Virus2-Status: Not Scanned
X-O-Virus3-Status: No
X-O-Virus4-Status: No
X-O-Virus5-Status: Not Scanned
X-O-Image-Status: Not Scanned
X-O-Attach-Status: Not Scanned
X-SpheriQ-Ver: 4.2.04
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

I believe that dma_alloc_coherent will mark the kernel buffer as uncached at alocation time. 
But that is not my intention. I have mapped some user space memory to the kernel buffer and I wish to ensure that the contents of both are coherent and correctly ordered. 

In other words I wish to flush the contents of the kernel buffer to user space as soon as new data is available in my kernel buffer. How to do that? Will doing mysnc from the user space help?

Rather than flushing everytime (or msyncing) I intend to make my user-to-kernel mapping as non cacheable so that multiple flushing can be avoided.

Bhuvan 

> Hi,
>   I am working on an audio device driver development on Linux. I have a kernel buffer which I have mapped to user space using mmap call from user space. My problem is that the data which comes to the kernel buffer is getting dropped in user space and I get only 50-60% of the data which is randomly ordered. The user to kernel level buffer address translation code is fine and I suspect this data dropping is occurring coz the kernel buffer is cacheable. Please suggest me some way of making the entire buffer non cacheable. I am stuck on this for quite a while now. 

The dma mapping API (or the PCI equivalent) provide the neccessary
behaviours for DMA receive, DMA send and consistent memory space in a
portable fashion.

That may not be done using uncachable memory in all cases as not all
processors even support uncacheable memory spaces.

If you are using the ALSA core routines (snd_dma_alloc_coherent) then
ALSA already uses dma_alloc_coherent to ensure the memory is allocated
for the appropriate use and will be kernel marked uncached.

