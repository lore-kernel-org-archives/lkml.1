Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbYGRJFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbYGRJFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbYGRJFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:05:04 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:38829 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbYGRJFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:05:03 -0400
Date: Fri, 18 Jul 2008 11:04:19 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       kernel <kernel@avr32linux.org>
Subject: Re: [PATCH] avr32: clean up mci platform code
Message-ID: <20080718110419.33581cd0@siona.local>
In-Reply-To: <1216363689.4004.80.camel@moss.renham>
References: <1216363689.4004.80.camel@moss.renham>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jul 2008 09:04:22.0302 (UTC) FILETIME=[44EAC3E0:01C8E8B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008 16:48:09 +1000
Ben Nizette <bn@niasdigital.com> wrote:

> This patch does a few small cleanups around the atmel mci platform code
> and in the atmel-mci driver.  The platform changes simply removes an
> unused variable, uses the fact that by the end we always have some form
> of platform data and notes that GPIO_PIN_NONE != 0.  This last point
> could cause the incorrect attempt to twice reserve pin PA0.

Indeed. The if (data) check is useless too since we make sure data
always points to something.

We should probably set the invalid pins to something like -EINVAL
eventually, but for now GPIO_PIN_NONE is consistent with everything
else around there.

> While we've got the hood up, add linux/err.h to the atmel-mci.c include
> list.  It needs it and generally pulls it by voodoo but I did once
> stumble across a config which don't build.

Yes, including linux/err.h is definitely the right thing to do.

> This is against Linus' latest git.
> 
> Signed-off-by: Ben Nizette <bn@niasdigital.com>

I've applied it to the avr32 tree since it touches mostly avr32 arch
code. Thanks a lot, Ben!

Haavard
