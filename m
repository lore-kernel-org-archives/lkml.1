Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbYIYSsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbYIYSsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYIYSry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:47:54 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:44719 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbYIYSrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:47:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ISYJGhKrL0xK85h06oaC6KVDA26CeqZ4vJwX3VqE8bnEN2g5sJs6sEIF8QBTv2OBHR
         w8qkGGbd79Livh6Yr/q/gfDG6AnouiXyoSw2dnsALXgvbXUJGzHvVQPRxB9cxaTp835p
         dXMaKitxotkGotSN4fQtsGInTDT0WHxFN/rP8=
Message-ID: <ed82fe3e0809251147t30743080v593d194eba731a7b@mail.gmail.com>
Date: Thu, 25 Sep 2008 13:47:52 -0500
From: "Timur Tabi" <timur@freescale.com>
To: "Scott Wood" <scottwood@freescale.com>
Subject: Re: [PATCH v2] fsl-dma: allow Freescale Elo DMA driver to be compiled as a module
Cc: "Li Yang" <leoli@freescale.com>, linuxppc-dev@ozlabs.org,
       dan.j.williams@intel.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080925184020.GA5230@ld0162-tx32.am.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222293567-17694-1-git-send-email-timur@freescale.com>
	 <2a27d3730809242354u4cc24b96yda3973bfc3ddac92@mail.gmail.com>
	 <48DB9816.4020603@freescale.com>
	 <20080925184020.GA5230@ld0162-tx32.am.freescale.net>
X-Google-Sender-Auth: 5a777976ca52ff0b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 1:40 PM, Scott Wood <scottwood@freescale.com> wrote:

> If there's a dependency there, how will it work when this is built as a
> module?

There are no dependencies.  fsldma registers with the DMA engine,
which is always built in-kernel.  The DMA engine is what handles
linking DMA clients to DMA drivers. The DMA clients get a callback
whenever a DMA driver registers with the DMA engine.  If the DMA
driver is already registered when the client registers, then the
client will get a callback immediately after it registers.

I chose subsys_initcall() to increase the probability that fsldma is
already present when DMA clients are loaded/initialized and register.

-- 
Timur Tabi
Linux kernel developer at Freescale
