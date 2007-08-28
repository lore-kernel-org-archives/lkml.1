Return-Path: <linux-kernel-owner+w=401wt.eu-S1761103AbXH1UWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761103AbXH1UWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbXH1UVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:21:52 -0400
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:33483 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbXH1UVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:21:51 -0400
Date: Tue, 28 Aug 2007 22:21:19 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, Bob Picco <bob.picco@hp.com>,
       john stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "double" hpet clocksource && hard freeze [bisected]
Message-ID: <20070828222119.5ef295e3@localhost>
In-Reply-To: <20070828102709.sybsmvvdw0o8swo4@webmail.df.eu>
References: <20070828102709.sybsmvvdw0o8swo4@webmail.df.eu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007 10:27:09 +0200
Clemens Ladisch <clemens@ladisch.de> wrote:

> Luck, Tony wrote:
> > [...] Given that the hang went away when you applied the earlier patch, I
> > conclude that the drivers/char/hpet.c code is the one that got selected when
> > you had two "hpet" entries ... and that there is something wrong with that
> > code that doesn't work right on x86_64.  
> 
> Apparently, the 'generic' code was just copied from ia64 and assumes that the
> timer is 64 bits.  This is not true with hardware from VIA (even on x86_64).

The hardware of this PC is Intel, not VIA.

> 
> This patch should make it work (although I'd prefer to set the mask  
> dynamically
> according to the hardware caps).
> 
> --- a/drivers/char/hpet.c	Tue Aug 28 09:42:22 2007
> +++ b/drivers/char/hpet.c	Tue Aug 28 10:16:54 2007
> @@ -73,7 +73,7 @@
>           .name           = "hpet",
>           .rating         = 250,
>           .read           = read_hpet,
> -        .mask           = CLOCKSOURCE_MASK(64),
> +        .mask           = CLOCKSOURCE_MASK(32),


Anyway, I've applied it (manually... whitespace/mime damage) to -rc4 and
it seems to work, no crash so far (I'm sure I'm testing it because
plain -rc4 doesn't have the "2hpet" fix and still manifest the problem).

-- 
	Paolo Ornati
	Linux 2.6.23-rc4-dirty on x86_64
