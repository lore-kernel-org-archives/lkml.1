Return-Path: <linux-kernel-owner+w=401wt.eu-S1761405AbZBXWcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405AbZBXWcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761118AbZBXWcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:32:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:57997 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761077AbZBXWcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:32:22 -0500
Subject: Re: [rtc-linux] [PATCH/RFC 0/5] Generic RTC class driver
From: David Woodhouse <dwmw2@infradead.org>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       rtc-linux@googlegroups.com, Richard Zidlicky <rz@linux-m68k.org>,
       linux-parisc@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       David@ozlabs.org, Kyle McMartin <kyle@mcmartin.ca>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <20090224231154.60ba18d6@i1501.lan.towertech.it>
References: <1235144809-32468-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <20090220170454.04382e9e@i1501.lan.towertech.it>
	 <alpine.LRH.2.00.0902231319170.22762@vixen.sonytel.be>
	 <1235511327.18632.73.camel@macbook.infradead.org>
	 <20090224231154.60ba18d6@i1501.lan.towertech.it>
Content-Type: text/plain
Date: Wed, 25 Feb 2009 07:32:07 +0900
Message-Id: <1235514727.18632.93.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-24 at 23:11 +0100, Alessandro Zummo wrote:
> On Wed, 25 Feb 2009 06:35:27 +0900
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > > So you want us to kill the ppc_md.[gs]et_rtc_time() [ppc], mach_hwclk() [m68k],
> > > mach_gettod() [m68knommu] (and probably a few other) abstractions, and move all
> > > RTC code out of arch/ into seperate drivers under drivers/rtc/ instead?
> > 
> > That's the ideal... although did we get NTP sync working again yet?
> 
>  not yet. we're close but I've been very busy :(

I know the feeling.

Once that's working, we can convert individual PPC platforms over,
removing the routines from the ppc_md and creating a generic RTC driver
instead. PA Electra is already like that -- because it wasn't a
regression there to have broken NTP sync. But the others need to wait.

Eventually, we ought to be able to drop the RTC functions from the
ppc_md -- and presumably the equivalent for other architectures too.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

