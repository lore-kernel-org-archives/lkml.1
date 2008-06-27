Return-Path: <linux-kernel-owner+w=401wt.eu-S1763529AbYF0ScH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763529AbYF0ScH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758731AbYF0Sbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:31:52 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:29046 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbYF0Sbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:31:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=OEhWUp4b6DGlGKCIhCEsk0qHt+mkZfd0mqrOBQbLVVYxHdj4Jdc9USY6ST/+9O0fCO
         eVRTErpnT0udNWYI4tvNapxqxp3S2Uq6iup3406gTkDCB3UTiVPbSzi1fKkhXcSUcaUi
         zJ5hzSJsOg+Cp5NnuaaWw/9lxC16x4RGbBNbo=
Message-ID: <e9c3a7c20806271131i5a4f5afg94fd21a89923ffbb@mail.gmail.com>
Date: Fri, 27 Jun 2008 11:31:49 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH v4 4/6] dmaengine: Make DMA Engine menu visible for AVR32 users
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, kernel@avr32linux.org,
       "Nelson, Shannon" <shannon.nelson@intel.com>
In-Reply-To: <200806271124.42783.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
	 <200806270937.21850.david-b@pacbell.net>
	 <20080627174441.GB4306@cs181140183.pp.htv.fi>
	 <200806271124.42783.david-b@pacbell.net>
X-Google-Sender-Auth: c309e36bc340ffda
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 11:24 AM, David Brownell <david-b@pacbell.net> wrote:
> On Friday 27 June 2008, Adrian Bunk wrote:
>> The only effect of the HAVE_DMA_ENGINE would be to not show an empty
>> kconfig menu.
>
> Well, no.  It would also make the network layer memcpy "acceleration"
> option unavailable when there was no underlying engine ... similarly
> with other pointless "we don't have that subsystem here" options.
>

Take another look.  NET_DMA depends on DMA_ENGINE which only gets
selected when a dma device driver is selected.  Each driver has its
architecture specific dependency, so the DMADEVICES arch dependency
was completely redundant.

> Plus it would help ensure that the arch dependencies are comprehenible,
> unlike that highmem thing.

The highmem dependency can go away its only purpose is to prevent
hitting the BUILD_BUG_ON in async_xor.c.

--
Dan
