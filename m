Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbZC3MFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbZC3MFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbZC3MFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:05:05 -0400
Received: from relay.atmel.no ([80.232.32.139]:53802 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbZC3MFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:05:04 -0400
Date: Mon, 30 Mar 2009 14:04:56 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Erik Waling <erik.waling@konftel.se>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] macb: RLE and BNA handling
Message-ID: <20090330140456.07eb48b8@hskinnemoen-d830>
In-Reply-To: <1238060296.23641.8.camel@konftel>
References: <1231863713.10152.11.camel@konftel>
	<20090114111505.48d34949@hskinnemoen-d830>
	<1231928868.10152.31.camel@konftel>
	<20090114130322.483a7830@hskinnemoen-d830>
	<1232026671.10152.52.camel@konftel>
	<1238060296.23641.8.camel@konftel>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erik Waling wrote:
> Have you had the time to check the patch below? These two issues still
> needs to be addressed.

Yeah...sorry for not responding earlier.

> If you are unsure of the BNA part you could at least pass the RLE part
> upstreams since it happens more frequently.

Right. I have to admit I'm not at all convinced about the BNA part...it
seems to me like the only scenario when it makes a difference is when
the ring is so small that it can't hold an entire frame. And if that's
the case, isn't the easiest solution to just increase the size of the
ring?

So, could you please split the patch up into the following parts:
  1. TX RLE handling
  2. Call macb_rx() regardless of the status
  3. Handle incomplete RX frames
  4. Special case for RX BNA

Then I can pass on the first three, and we can keep discussing the last
one, which is the one I'm not sure about.

Haavard
