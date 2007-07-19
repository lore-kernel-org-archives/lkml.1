Return-Path: <linux-kernel-owner+w=401wt.eu-S964942AbXGSJbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964942AbXGSJbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760526AbXGSJbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:31:40 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:56632 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755717AbXGSJbj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:31:39 -0400
Date: Thu, 19 Jul 2007 11:31:36 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>,
       David Brownell <david-b@pacbell.net>,
       Andrew Victor <andrew@sanpeople.com>,
       kernel-avr32 <kernel@avr32linux.org>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Nicolas FERRE <nicolas.ferre@rfo.atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] Driver for the Atmel on-chip SSC on AT32AP and
 AT91.
Message-ID: <20070719113136.4d0a951f@dhcp-255-175.norway.atmel.com>
In-Reply-To: <20070719110122.262c2778@dhcp-255-175.norway.atmel.com>
References: <1184568752.15535.9.camel@localhost.localdomain>
	<20070718170120.8a031cdf.akpm@linux-foundation.org>
	<469F0A78.3040808@atmel.com>
	<20070719110122.262c2778@dhcp-255-175.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops, didn't notice that Andrew and LKML fell off Cc. Sorry.

Håvard

On Thu, 19 Jul 2007 11:01:22 +0200
Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> On Thu, 19 Jul 2007 08:53:44 +0200
> Hans-Christian Egtvedt <hcegtvedt@atmel.com> wrote:
> 
> > >> +EXPORT_SYMBOL(ssc_request);
> > >>       
> > >
> > > All exports need justification, please.  An additional paragraph in the
> > > changelog would suit.
> > >     
> > How are exports justified? Can they be removed since the user have to 
> > include <linux/atmel-ssc.h> anyway?
> 
> No, we do need these since modules are going to link to them.
> 
> The idea is that other drivers call these functions to obtain a
> reference to one of the SSC instances in the system. Such drivers
> typically implement some sort of serial frame-based protocol, e.g. i2s,
> by programming the SSC controller directly. This driver is out of the
> way after a protocol driver has successfully requested an instance.
> 
> So the protocol drivers need some kind of resource management in order
> to not step on each others' toes, and that's the reason for the export
> of ssc_request() and ssc_free().
> 
> I'm not sure if anyone would have been very mad at me for sneaking this
> in through the avr32 tree, but I'd really like to know what others, in
> particular the AT91 people and David, think of this kind of thing
> before it ends up in mainline.
> 
> Feel free to add
> 
> Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> 
> to both patches (the driver and the fix) though. It's been through a
> few rounds of internal review.
> 
> Håvard
> _______________________________________________
> Kernel mailing list
> Kernel@avr32linux.org
> http://duppen.flaskehals.net/cgi-bin/mailman/listinfo/kernel
