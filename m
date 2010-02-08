Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0BHKUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 05:20:12 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65221 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839Ab0BHKUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 05:20:10 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Pavel Machek <pavel@ucw.cz>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20100208073334.GB7171@rhlx01.hs-esslingen.de>
References: <20100208073334.GB7171@rhlx01.hs-esslingen.de>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 08 Feb 2010 10:19:44 +0000
Message-Id: <1265624384.4020.25.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Feb 2010 10:19:46.0036 (UTC) FILETIME=[3CBB4B40:01CAA8A8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-08 at 07:33 +0000, Andreas Mohr wrote:
> On Mon, Feb 08, 2010 at 07:55:19AM +0100, Pavel Machek wrote:
> > Plus it does unneccessary flushes on x86, etc...
> 
> Noticed that as well, there should be an arch-obeying helper for this.
> 
> 
> On my MIPSEL, I had urb->transfer_buffer NULL ptr crashes
> (I think that was expected in case of a certain DMA setup, Alan said).
> 
> However, even with NULL check added I still had:
> 
> hub 2-1.1:1.0: state 7 ports 7 chg 0000 evt 0010
> Unhandled kernel unaligned access[#1]:

Just to avoid confusion - that's a similar patch applied to a different
driver. The ISP1760 HCD driver works fine with my patch (transfer_buffer
never seems to be NULL with latest mainline). I can't comment on the
ehci-q.c driver (it looks like it has some support for DMA while my
patch only applies to PIO drivers where transfer_buffer should be set).

-- 
Catalin

