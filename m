Return-Path: <linux-kernel-owner+w=401wt.eu-S2992947AbXDTNjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992947AbXDTNjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 09:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993248AbXDTNjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 09:39:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36345 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753537AbXDTNju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 09:39:50 -0400
Date: Fri, 20 Apr 2007 14:43:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bhuvan Kumar MITTAL <bhuvan.mittal@st.com>
Cc: <linux-kernel@vger.kernel.org>, <bhuvan.mittal@st.com>
Subject: Re: How to make mmap'ed kernel buffer non-cacheable
Message-ID: <20070420144312.74ec1ebd@the-village.bc.nu>
In-Reply-To: <000201c7834b$dda8c6c0$142ec70a@dlh.st.com>
References: <000201c7834b$dda8c6c0$142ec70a@dlh.st.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 18:30:25 +0530
Bhuvan Kumar MITTAL <bhuvan.mittal@st.com> wrote:

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
