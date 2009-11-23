Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZKWPU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZKWPU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 10:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbZKWPU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 10:20:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45216 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754781AbZKWPUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 10:20:54 -0500
Date: Mon, 23 Nov 2009 15:20:57 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: mfd tree build failure
Message-ID: <20091123152057.GH24326@rakim.wolfsonmicro.main>
References: <20091123144103.73b4d64c.sfr@canb.auug.org.au>
 <20091123150346.e3948feb.sfr@canb.auug.org.au>
 <20091123122903.GB3616@sortiz.org>
 <20091123131113.GE24326@rakim.wolfsonmicro.main>
 <20091123144413.GD3616@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123144413.GD3616@sortiz.org>
X-Cookie: Avoid contact with eyes.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 03:44:14PM +0100, Samuel Ortiz wrote:
> On Mon, Nov 23, 2009 at 01:11:13PM +0000, Mark Brown wrote:

> > I don't see getting them exported flying, especially not in the
> > timeframe we've got for the merge window.  Keeping them non-exported has
> > been a deliberate decision on the part of the genirq maintainers. 

> Out of curiosity, what's the reasoning behind thatdecision ?

Unless you're actually implementing an interrupt controller those APIs
should never be called and people should be using flags on request_irq()
or similar.  Driver authors have been awfully fond of bypassing those
APIs, but this prevents them doing so.

None of this is really a practical issue unless you implement an IRQ
controller in a driver and that's very rare (or has been up until now).
