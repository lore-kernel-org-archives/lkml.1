Return-Path: <linux-kernel-owner+w=401wt.eu-S1751233AbZJVXXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233AbZJVXXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 19:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbZJVXXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 19:23:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60958 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbZJVXXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 19:23:11 -0400
Message-ID: <4AE0E938.7080305@ti.com>
Date: Thu, 22 Oct 2009 18:22:32 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: Re: [PATCH 05/10] omap1: Fix DSP public peripherals support for ams-delta
References: <20091022221013.27408.443.stgit@localhost> <20091022221216.27408.39863.stgit@localhost>
In-Reply-To: <20091022221216.27408.39863.stgit@localhost>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tony Lindgren wrote:
> From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> 
> DSP public peripherals used to work on OMAP1510 based (or all OMAP1 class?)
> machines as long as old dspgateway code were present in the l-o tree. For
> several months it is no longer included, breaking support for McBSP1 based
> audio on Amstrad Delta, for example.
> 
> This patch, derived from the old dspgateway code, corrects the problem for the
> board by simply taking the DSP out of reset state, I guess. That way, things
> should not break when a new dsp code is added to the tree, and the change can
> be reverted then.

A minor comment/correction here. Although this bit is called "DSP_RST" 
this does not actually release the DSP from reset. This bit actually 
releases the reset for the "priority registers (TIPB module), EMIF 
configuration registers, and the MPUI control logic (partially) in the 
DSP", thus allowing you to access the DSP peripherals via the MPUI. Bit 
1 of the same register, called "DSP_EN", actually releases the DSP reset.

> If there are any reports on McBSP1 or other DSP public peripherals not working
> for other OMAP1 machines (I've not heard of any for now), I can prepare a more
> general patch providing an extra include file with a helper function defined.

This would be necessary for all OMAP15xx based devices that use McBSP1 
(or McBSP3 for that matter). However, I am not sure if it is common for 
other boards to use McBSP1 for audio.

Jon
