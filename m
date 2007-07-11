Return-Path: <linux-kernel-owner+w=401wt.eu-S1765363AbXGKQ4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765363AbXGKQ4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 12:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbXGKQ4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 12:56:33 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:3046 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbXGKQ4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 12:56:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XSII5T28ZIn5YJjQf0j+s1K7YynxE08Fki1QQjm3+WfKhsjdJTrXEjDblJ+uPXEQ9dFoe/8GSrl8OHZ62mNKDNZke7xV7ctzKMJXpBF/78V5v1c/Jwb0JOfEtA5xIE5JVnS2l5dkswg7iCyqH4Me6Mw6NqWn0zMacwRt5Nc25K0=
Message-ID: <e9c3a7c20707110956r5ea91fd1q1d0b33b9583fe91c@mail.gmail.com>
Date: Wed, 11 Jul 2007 09:56:31 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
Subject: Re: [PATCH 3/4] Extend the DMA-engine API.
Cc: akpm@linux-foundation.org, paulus@samba.org, galak@kernel.crashing.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       shannon.nelson@intel.com
In-Reply-To: <46B96294322F7D458F9648B60E15112C6F3CED@zch01exm26.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11840607111926-git-send-email-wei.zhang@freescale.com>
	 <e9c3a7c20707101141m17e313e2k99be5b7197edc910@mail.gmail.com>
	 <46B96294322F7D458F9648B60E15112C6F3CED@zch01exm26.fsl.freescale.net>
X-Google-Sender-Auth: 4ef018d36218ff11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/07, Zhang Wei-r63237 <Wei.Zhang@freescale.com> wrote:
> Hi, Dan,
>
> Do you mention here: http://marc.info/?l=linux-raid&m=118290909614463&w=2 ?
> I see the async_tx is located at crypto/ of the above page, but my patch is for DMA engine in drivers/dma and for DMA engine driver.
>
> Thanks!
> Wei.

Hi Wei,

I was referring to:
http://marc.info/?l=linux-raid&m=118290909528910&w=2

async_tx is an api that exploits the raw capabilities of the new
dmaengine interface.  For your case when the existing api calls do not
provide the proper interface you can open code something like the
following:

tx = dev->device_prep_dma_<operation>(chan, len, int_flag)
tx->tx_set_src(dma_addr_t, tx, index /* for multi-source ops */)
tx->tx_set_dest(dma_addr_t, tx, index)
tx->tx_submit(tx)

The expectation is that the most common usages of dmaengines will use
async_tx calls, or the 'dma_async_memcpy_foo_to_bar' helper routines.

--
Dan
