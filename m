Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYE1Il6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYE1Il6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 04:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbYE1Ilt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 04:41:49 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:39083 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbYE1Ils (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 04:41:48 -0400
X-Greylist: delayed 89651 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 May 2008 04:41:48 EDT
Date: Wed, 28 May 2008 10:36:48 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: benh@kernel.crashing.org
Cc: Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com
Subject: Re: MMIO and gcc re-ordering issue
Message-ID: <20080528103648.54eb8734@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <1211926636.3286.100.camel@pasglop>
References: <1211852026.3286.36.camel@pasglop>
	<20080526.184047.88207142.davem@davemloft.net>
	<1211854540.3286.42.camel@pasglop>
	<20080526.192812.184590464.davem@davemloft.net>
	<1211859542.3286.46.camel@pasglop>
	<alpine.LFD.1.10.0805270833060.2958@woody.linux-foundation.org>
	<1211922621.3286.80.camel@pasglop>
	<alpine.LFD.1.10.0805271421570.2958@woody.linux-foundation.org>
	<1211924335.3286.89.camel@pasglop>
	<20080527214241.GA22636@parisc-linux.org>
	<1211926636.3286.100.camel@pasglop>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2008 08:36:38.0759 (UTC) FILETIME=[F24CFF70:01C8C09D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> > > I'm happy to say that __raw is purely about ordering and make them
> > > byteswap on powerpc tho (ie, make them little endian like the non-raw
> > > counterpart).  
> > 
> > That would break a lot of drivers.  
> 
> How many actually use __raw_ * ?

I do -- in all the drivers for on-chip peripherals that are shared
between AT91 ARM (LE) and AVR32 (BE). Since everything goes on inside
the chip, we must use LE accesses on ARM and BE accesses on AVR32.

Currently, this is the only interface I know that can do native-endian
accesses, so if you take it away, I'm gonna need an alternative
interface that doesn't do byteswapping.

Haavard
