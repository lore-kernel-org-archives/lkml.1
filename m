Return-Path: <linux-kernel-owner+w=401wt.eu-S1751477AbXCGPFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbXCGPFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 10:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbXCGPFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 10:05:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54529 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbXCGPFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 10:05:22 -0500
Subject: Re: Wanted: simple, safe x86 stack overflow detection
From: Arjan van de Ven <arjan@infradead.org>
To: Bill Irwin <bill.irwin@oracle.com>
Cc: Hugh Dickins <hugh@veritas.com>, Chuck Ebbert <cebbert@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070307144816.GQ18774@holomorphy.com>
References: <45E5913D.3080505@redhat.com>
	 <20070228204144.GA32316@one.firstfloor.org>
	 <20070304015031.GA4224@holomorphy.com> <45EDBA1B.8050007@redhat.com>
	 <Pine.LNX.4.64.0703061937450.19813@blonde.wat.veritas.com>
	 <20070306203432.GD18774@holomorphy.com>
	 <1173241715.3236.16.camel@laptopd505.fenrus.org>
	 <20070307064423.GH18774@holomorphy.com>
	 <1173270892.3176.4.camel@laptopd505.fenrus.org>
	 <20070307144816.GQ18774@holomorphy.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 07 Mar 2007 07:04:23 -0800
Message-Id: <1173279863.3540.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > just removing the if() and the explicit IRQ enabling already makes irqs no longer nest...
> 
> I can see why that would raise eyebrows. I can see getting bashed
> mercilessly with interrupt latency concerns as a result here. Can you
> suggest any defenses?


hardirq handlers are supposed to be fast. If they're slow the code
should (and generally is) using bottom halves/tasklets/softirqs. Combine
this with the fact that each new irq handler will start with a bunch of
cache misses, the latency added isn't generally that significant. In
addition, the cache miss thing makes the nesting suck a lot, it's faster
to batch the irqs in sequence.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

