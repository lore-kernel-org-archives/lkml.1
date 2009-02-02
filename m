Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbZBBPCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbZBBPCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 10:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZBBPCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 10:02:06 -0500
Received: from relay.atmel.no ([80.232.32.139]:58078 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbZBBPCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 10:02:05 -0500
Date: Mon, 2 Feb 2009 16:01:35 +0100
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       "kernel@avr32linux.org" <kernel@avr32linux.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hskinnemoen@atmel.com" <hskinnemoen@atmel.com>
Subject: Re: [PATCH] atmel-mci: fix initialization of dma slave data
Message-ID: <20090202160135.3b10233f@hcegtvedt>
In-Reply-To: <1233419203.5959.6.camel@dwillia2-linux.ch.intel.com>
References: <20090130230248.2402.65405.stgit@dwillia2-linux.ch.intel.com>
	<20090131.210651.126573837.anemo@mba.ocn.ne.jp>
	<20090131.235230.90118475.anemo@mba.ocn.ne.jp>
	<1233419203.5959.6.camel@dwillia2-linux.ch.intel.com>
Organization: Atmel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jan 2009 09:26:43 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Subject: atmel-mci: fix initialization of dma slave data
> 
> From: Dan Williams <dan.j.williams@intel.com>
> 
> The conversion of atmel-mci to dma_request_channel missed the
> initialization of the channel dma_slave information.  The filter_fn
> passed to dma_request_channel is responsible for initializing the
> channel's private data.  This implementation has the additional
> benefit of enabling a generic client-channel data passing mechanism.
> 

FWIW I ran this through an ALSA sound driver I'm working on for AVR32,
uses the DW DMA controller and this was exactly what I needed to pass
on the information about the slave. Seems to behave fine on my setup,
I'm working against the 2.6.29-rc3 tag.

> Reviewed-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

<snipp patch which adds a private pointer to struct dma_chan>

-- 
Best regards,
Hans-Christian Egtvedt
