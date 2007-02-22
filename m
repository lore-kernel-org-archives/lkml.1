Return-Path: <linux-kernel-owner+w=401wt.eu-S1946010AbXBVOJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946010AbXBVOJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 09:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946013AbXBVOJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 09:09:46 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38413 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946010AbXBVOJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 09:09:45 -0500
Subject: Re: [kvm-devel] [PATCH 10/13] KVM: Wire up hypercall handlers to
	a	central arch-independent location
From: Arjan van de Ven <arjan@infradead.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Dor Laor <dor.laor@qumranet.com>, Pavel Machek <pavel@ucw.cz>,
       kvm-devel@lists.sourceforge.net, akpm@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <45DD9A9D.4060500@qumranet.com>
References: <45D979D3.2020907@qumranet.com>
	 <20070219103052.4D23725016B@il.qumranet.com><20070221103733.GI3945@ucw.cz>
	 <45DD6CF0.3010509@qumranet.com>
	 <64F9B87B6B770947A9F8391472E032160A91BAF3@ehost011-8.exch011.intermedia.net>
	 <1172140490.3531.236.camel@laptopd505.fenrus.org>
	 <45DD7330.1030001@qumranet.com>
	 <1172142081.3531.243.camel@laptopd505.fenrus.org>
	 <45DD94D3.4030102@qumranet.com>
	 <1172149924.3531.260.camel@laptopd505.fenrus.org>
	 <45DD9A9D.4060500@qumranet.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 22 Feb 2007 15:09:33 +0100
Message-Id: <1172153373.3531.268.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Can't it be done by a helper function using a timer and a signal (or 
> whatever mechanism we use to wake up vcpus)?

one could do that but it's not optimal; if the process DOES get waken up
earlier, it should take the interrupt then immediately, so that it
doesn't have to wake up again when the timer fires. 

(in fact it would be nice if the guest could somehow poll at the irq
mask at waking from idle, so that it wouldn't need a vmexit/entry for
every such interrupt, but just do the right thing for all pending work)

In addition, yes it'll be a helper function, but since all drivers will
want the functionality its probably best off in the generic code


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

