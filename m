Return-Path: <linux-kernel-owner+w=401wt.eu-S1756956AbYIRV6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbYIRV6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 17:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbYIRV6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 17:58:10 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:58082 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbYIRV6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 17:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=a6RPFpEbctS/cr4cqrZFhZFN2PC7ZbhBGLQp3Uv3q4Nlsw6vwVN3I8bPqUZ0Q2Sjyw
         JT5SrOu23+2wblZJCuHNYAcdySf9KjFSdD0pAlZ0r9b41CZQ+03KRqyeMRMFejS1pMsk
         QSZzlqmWoym7loaGG8T69ci1Z0cTJPhDRNiys=
Message-ID: <e9c3a7c20809181458p4cabccblfde6a92bf35976ee@mail.gmail.com>
Date: Thu, 18 Sep 2008 14:58:07 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Timur Tabi" <timur@freescale.com>
Subject: Re: Problems with Freescale DMA driver
Cc: linux-kernel@vger.kernel.org, maciej.sosnowski@intel.com,
       leoli@freescale.com, zw@zh-kernel.org,
       "Ira Snyder" <iws@ovro.caltech.edu>
In-Reply-To: <20080825165133.GA20446@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080825165133.GA20446@ovro.caltech.edu>
X-Google-Sender-Auth: fc1c74be40ad96a0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding Timur to the cc]

On Mon, Aug 25, 2008 at 9:51 AM, Ira Snyder <iws@ovro.caltech.edu> wrote:
> Hello LKML,
>
> I'm developing on a Freescale MPC8349EA MDS evaluation board. I'm
> currently testing the DMA controller. It uses the CONFIG_FSL_DMA driver.
>
> All tests were done with a recent git pull.
>
> I built the CONFIG_DMATEST DMA test client, and it runs perfectly in the
> absence of other DMA activity. Enabling CONFIG_NET_DMA and running the
> DMA test client while network traffic is running causes failures such as
> the following:
>
> of-fsl-dma-channel e0008100.dma-channe: DMA halt timeout!
> dma0chan0-test0: dstbuf[0x9c0] mismatch! Expected c2, got df
> dma0chan0-test0: dstbuf[0x9c1] mismatch! Expected c1, got df
> dma0chan0-test0: dstbuf[0x9c2] mismatch! Expected c0, got df
> dma0chan0-test0: dstbuf[0x9c3] not copied! Expected df, got 3c
> dma0chan0-test0: dstbuf[0x9c4] not copied! Expected de, got 3b
> dma0chan0-test0: dstbuf[0x9c5] not copied! Expected dd, got 3a
> dma0chan0-test0: dstbuf[0x9c6] not copied! Expected dc, got 39
> dma0chan0-test0: dstbuf[0x9c7] not copied! Expected db, got 38
> dma0chan0-test0: dstbuf[0x9c8] not copied! Expected da, got 37
> dma0chan0-test0: dstbuf[0x9c9] not copied! Expected d9, got 36
> dma0chan0-test0: dstbuf[0x9ca] not copied! Expected d8, got 35
> dma0chan0-test0: dstbuf[0x9d8] mismatch! Expected ca, got c2
> dma0chan0-test0: dstbuf[0x9d9] mismatch! Expected c9, got c1
> dma0chan0-test0: dstbuf[0x9da] mismatch! Expected c8, got c0
> dma0chan0-test0: dstbuf[0x9db] mismatch! Expected c7, got df
> dma0chan0-test0: dstbuf[0x9dc] mismatch! Expected c6, got de
> dma0chan0-test0: dstbuf[0x9dd] mismatch! Expected c5, got dd
> dma0chan0-test0: dstbuf[0x9de] mismatch! Expected c4, got dc
> dma0chan0-test0: dstbuf[0x9df] mismatch! Expected c3, got db
> dma0chan0-test0: dstbuf[0x9e0] mismatch! Expected c2, got da
> dma0chan0-test0: dstbuf[0x9e1] mismatch! Expected c1, got d9
> dma0chan0-test0: dstbuf[0x9e2] mismatch! Expected c0, got d8
> dma0chan0-test0: dstbuf[0x9e3] mismatch! Expected df, got d7
> dma0chan0-test0: dstbuf[0x9e4] mismatch! Expected de, got d6
> dma0chan0-test0: dstbuf[0x9e5] mismatch! Expected dd, got d5
> dma0chan0-test0: dstbuf[0x9e6] mismatch! Expected dc, got d4
> dma0chan0-test0: dstbuf[0x9e7] mismatch! Expected db, got d3
> dma0chan0-test0: dstbuf[0x9e8] mismatch! Expected da, got d2
> dma0chan0-test0: dstbuf[0x9e9] mismatch! Expected d9, got d1
> dma0chan0-test0: dstbuf[0x9ea] mismatch! Expected d8, got d0
> dma0chan0-test0: dstbuf[0x9eb] mismatch! Expected d7, got cf
> dma0chan0-test0: dstbuf[0x9ec] mismatch! Expected d6, got ce
> dma0chan0-test0: 7011 errors suppressed
> dma0chan0-test0: #12268: 7043 errors with src_off=0x1b6b dst_off=0x96e len=0x1be2
>
> Is this to be expected? I thought the whole point of the DMAEngine API
> was to enable sharing of DMA channels.
>
> Another issue I noticed was running a network transfer from another
> computer to the board. I get the following in dmesg, varying numbers of
> times. This is with no other DMA activity running, dmatest is not
> loaded. NET_DMA should be the only thing using the controller:
>
> of-fsl-dma-channel e0008100.dma-channe: DMA halt timeout!
> of-fsl-dma-channel e0008100.dma-channe: DMA halt timeout!
> of-fsl-dma-channel e0008100.dma-channe: DMA halt timeout!
> of-fsl-dma-channel e0008100.dma-channe: DMA halt timeout!
> of-fsl-dma-channel e0008100.dma-channe: DMA halt timeout!
> of-fsl-dma-channel e0008100.dma-channe: DMA halt timeout!
> of-fsl-dma-channel e0008100.dma-channe: DMA halt timeout!
> of-fsl-dma-channel e0008100.dma-channe: DMA halt timeout!
> of-fsl-dma-channel e0008100.dma-channe: DMA halt timeout!
>
> On the run where the above errors were printed,
> /sys/class/dma/dma0chan0/memcpy_count increased by ~36000. Certainly the
> DMA halt error doesn't happen for every single dma transaction.
>
> Is this normal behavior, or is something broken in the driver?
>
> I've CC'd the maintainers responsible for the FSL DMA driver, as well as
> the generic DMA offload system.
>
> Please CC me on any responses, I'm not subscribed to LKML.
>
> I'm happy to help test any changes, or add information if it is needed,
> please just ask.
>
> Thanks,
> Ira
