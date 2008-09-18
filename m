Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbYIROOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbYIROOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 10:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYIRON7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 10:13:59 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:12297 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYIRON6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 10:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Lb5fJrHGrNtw/OYCFoB0CLjdWOkLMRXzPg/Mnh52NDIKyd6hN71nYKKI60BXI4aK2u
         3SMvxdZqBZbC1bajRf3cxXG5yp/Caky0SuZ4Zy8VzYoKnkPlnDIP2msA/TMPLzHSDFHH
         +sDRKoq83xEHsa2SbeE9RbN7NsG17tko9KDfk=
Message-ID: <ed82fe3e0809180713v7e7a6115ya4612aa68879e39d@mail.gmail.com>
Date: Thu, 18 Sep 2008 09:13:56 -0500
From: "Timur Tabi" <timur@freescale.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: dmaengine.c: question about device_alloc_chan_resources
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
In-Reply-To: <e9c3a7c20809171536i189e3816x8572055d932c3c4c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48D02589.8070601@freescale.com>
	 <e9c3a7c20809171536i189e3816x8572055d932c3c4c@mail.gmail.com>
X-Google-Sender-Auth: 40f9ba5b8ff115c4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 5:36 PM, Dan Williams <dan.j.williams@intel.com> wrote:

> I believe the problem is that dmatest is telling the core to take
> multiple references on a channel.  Take a look at
> net/core/dev.c:netdev_dma_event and
> crypto:asynx_tx/async_tx.c:dma_channel_add_remove both of those check
> to see if they already have a refence to the channel.

Ok, I see what these functions are doing, and dmatest_add_channel() is
not doing it.  dmatest_add_channel() should not assume that it will
only receive one and only one DMA_RESOURCE_AVAILABLE for each channel.

I'll post a patch, if Haavard doesn't do it first.  Thanks for looking
into this and getting back to me.  I've spent the entire week
debugging this.

-- 
Timur Tabi
Linux kernel developer at Freescale
