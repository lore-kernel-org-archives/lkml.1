Return-Path: <linux-kernel-owner+w=401wt.eu-S1750872AbXBVNMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750872AbXBVNMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 08:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbXBVNMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 08:12:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36002 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbXBVNMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 08:12:14 -0500
Subject: Re: [kvm-devel] [PATCH 10/13] KVM: Wire up hypercall handlers to
	a	central arch-independent location
From: Arjan van de Ven <arjan@infradead.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Dor Laor <dor.laor@qumranet.com>, Pavel Machek <pavel@ucw.cz>,
       kvm-devel@lists.sourceforge.net, akpm@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <45DD94D3.4030102@qumranet.com>
References: <45D979D3.2020907@qumranet.com>
	 <20070219103052.4D23725016B@il.qumranet.com><20070221103733.GI3945@ucw.cz>
	 <45DD6CF0.3010509@qumranet.com>
	 <64F9B87B6B770947A9F8391472E032160A91BAF3@ehost011-8.exch011.intermedia.net>
	 <1172140490.3531.236.camel@laptopd505.fenrus.org>
	 <45DD7330.1030001@qumranet.com>
	 <1172142081.3531.243.camel@laptopd505.fenrus.org>
	 <45DD94D3.4030102@qumranet.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 22 Feb 2007 14:12:04 +0100
Message-Id: <1172149924.3531.260.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Somthing else that came up in a conversation with Dor: the need for a 
> clean way to raise a guest interrupt.  The guest may be sleeping in 
> userspace, scheduled out, or running on another cpu (and requiring an 
> ipi to get it out of guest mode).

yeah it'd be nice if I could just call a function for it rather than
poking into kvm internals ;)

> Right now I'm thinking about using the signal machinery since it appears 
> to do exactly the right thing.

signals are *expensive* though.

If you design an interrupt interface, it'd rock if you could make it
such that it is "raise <this> interrupt within <x> miliseconds from
now", rather than making it mostly synchronous. That way irq mitigation
becomes part of the interface rather than having to duplicate it all
over the virtual drivers...



-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

