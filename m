Return-Path: <linux-kernel-owner+w=401wt.eu-S1761370AbYBFVIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370AbYBFVIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757954AbYBFVIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:08:39 -0500
Received: from ik-out-1112.google.com ([66.249.90.176]:22204 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757854AbYBFVIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:08:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=L8rnrIRdgkuLfb6pyP3tUIQCeUIPUXVYSS2m5IJULKLdsReHUcTHpsY5uRQzSAKKwZuQ8bbMc+JX8jbxIC/1HG252PY2YpVGIKqSjNTxrpSLETXusCrT+hqKUWdEX9cQLlbJhuN8wgWDkOvgcXlSv4GUASFhP9jLoGv198DltO0=
Message-ID: <e9c3a7c20802061308q56cf7d25paae75aed9bde4035@mail.gmail.com>
Date: Wed, 6 Feb 2008 14:08:35 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [RFC v2 2/5] dmaengine: Add slave DMA interface
Cc: "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       "Shannon Nelson" <shannon.nelson@intel.com>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
In-Reply-To: <20080130132651.7320d301@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	 <200801292330.05874.david-b@pacbell.net>
	 <20080130102706.15c88346@dhcp-252-066.norway.atmel.com>
	 <200801300252.50344.david-b@pacbell.net>
	 <20080130132651.7320d301@dhcp-252-066.norway.atmel.com>
X-Google-Sender-Auth: 098179bd276dd25e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 5:26 AM, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
[..]
> Right. I'll add a "unsigned int engine_type" field so that engine
> drivers can go ahead and extend the standard dma_device structure.
> Maybe we should add a "void *platform_data" field to the dma_slave
> struct as well so that platforms can pass arbitrary platform-specific
> information to the DMA controller driver?
>

I think we can get away with not adding an engine_type field:
1/ For a given platform there will usually only be one driver active.
For example I have an architecture (IOP) specific dma_copy_to_user
implementation that can safely assume it is talking to the iop-adma
driver since ioat_dma and others are precluded by the Kconfig.
2/ If there was a situation where two dma drivers were active in a
system you could tell them apart by comparing the function pointers,
i.e. dma_device1->device_prep_dma_memcpy !=
dma_device2->device_prep_dma_memcpy.

--
Dan
