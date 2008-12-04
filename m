Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbYLDCoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbYLDCoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 21:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbYLDCoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 21:44:06 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:38479 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbYLDCoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 21:44:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EhWe9Uanmo92cFRO0wu3tRAS5AbcHcaWq+ZDWqGhiQIX9SWnBcvXVe/y9/A8XToxUy
         mxaytQv2RzWa0m+Vsnm4855+/Y8u6wp9cfcs353fxbXpqGv4Oi4TcVq1mm68YO9I1Hr/
         118IWAAr1wqtPtQUtMb6HciPSdEeWLpv5sV8c=
Message-ID: <208aa0f00812031844u779584e8q633a5f1b92a97426@mail.gmail.com>
Date: Wed, 3 Dec 2008 18:44:01 -0800
From: "Edward Estabrook" <edward.estabrook.lkml@gmail.com>
To: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
Cc: edward_estabrook@agilent.com, linux-kernel@vger.kernel.org,
       hjk@linutronix.de, gregkh@suse.de, edward.estabrook@gmail.com
In-Reply-To: <c384c5ea0812031400s58bcec3du7fc86802ad413e30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43FC624C55D8C746A914570B66D642610367F29B@cos-us-mb03.cos.agilent.com>
	 <c384c5ea0812031400s58bcec3du7fc86802ad413e30@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You are using a magic value to mmap(), just to keep options open:
>
> Would this in the future allow us to also add support for streaming
> non-coherent DMA directly into user space buffers?

Yes, but additional userspace control is also required.
Specifically:
 1) The specification of direction at the time of buffer creation,
    unless force DMA_BIDIRECTIONAL is assumed.
 2) An API to faciliate userspace control over dma_unmap_page() /
    dma_sync_single_for_cpu() calls (perhaps by further overloading
    of the write method).

The use of this magic value does not prevent the future addition of
streaming DMA support, but does not provide sufficient controls.
