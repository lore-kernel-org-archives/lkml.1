Return-Path: <linux-kernel-owner+w=401wt.eu-S1762453AbXF2JcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762453AbXF2JcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 05:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbXF2JcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 05:32:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:28956 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbXF2JcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 05:32:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=CJToROos+387ayV8jNrxyt21k+2Gv1bcv9VpdlogonO8BHfSAH2d6nGt8c/2Ib1L0vapPF/ZkV4qok0xGgdnyDC6IBXXDv5mnXrrrg6sKypFx5XtfD4w188br0c4Ld/IWJ504nBwtxzZs0xmmtDjAYeBQtxjUEjPI+lgqqOf4AE=
Message-ID: <4684D1E4.1030502@gmail.com>
Date: Fri, 29 Jun 2007 13:33:24 +0400
From: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@enneenne.com>
CC: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Yang-r58472 <LeoLi@freescale.com>,
       linux-usb-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [linux-usb-devel] [PATCH] PXA27x UDC driver.
References: <20070628103619.GW13886@enneenne.com>	<989B956029373F45A0B8AF0297081890D834FA@zch01exm26.fsl.freescale.net>	<20070628141205.GA13886@enneenne.com>	<200706281453.23414.david-b@pacbell.net> <20070629085801.GH13886@enneenne.com>
In-Reply-To: <20070629085801.GH13886@enneenne.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rodolfo Giometti wrote:
> On Thu, Jun 28, 2007 at 02:53:22PM -0700, David Brownell wrote:
>> Let's start with *JUST* a driver, not trying to update everything
>> else in the USB Gadget stack so that it looks like it's designed
>> specifically to handle all of Intel's design botches related to
>> endpoint config ... and work worse for essentially everything else.
>>
>> (Unlike pretty much every other vendor, Intel wanted hardware config
>> management.  It was unusably buggy in pxa21x/25x/26x, and not much
>> better in pxa27x.)
>>
>>
>> So in technical terms, and to repeat what I've said before:  just
>> configure it to act more like a PXA 25x chip (no altsettings) and
>> get it so it passes all the tests [1], modulo errata which have no
>> workarounds ... then submit that.  No epautoconfig updates, no
>> patches to every gadget driver to cope with updated autoconfig.
>
> This looks interesting... as you alredy told this driver derives from
> an older one, I just maintained it till now.
>
> If I well understand I should remove usb_ep_autoconfig() and program
> into the controller only one (the default) configuration. Is that
> right?
You should leave the usb_ep_autoconfig() as is, i.e. do not introduce
any new parameters to it.
>
> Currently I tested the driver only with ether gadget, 
Why have you submitted the limited driver then? You should test
the driver with all gadgets. Also, please report  how it works
in DMA and PIO modes. And what transfer rate the driver achives
in both modes.
> but if I do as
> above, should I get the driver working with all gadgets automagically?
Probably no, but technically there is no reason to not support
all gadgets.

BTW, I suggest that you wait until PXA3XX arch support will be
merged into mainline kernel, then, pxa27x_udc-compatible driver
will probably be submitted too. Taking into account that
pxa27_udc have not been merged for years, I think extra
2-3 month is ok.


Regards,
Dmitry

> :)
>
> Thanks a lot,
>
> Rodolfo
>

