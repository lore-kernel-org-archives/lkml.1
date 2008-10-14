Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbYJNXv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbYJNXv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 19:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYJNXvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 19:51:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068AbYJNXvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 19:51:45 -0400
Date: Tue, 14 Oct 2008 16:51:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: linux-next: origin tree build failure
In-Reply-To: <20081015095916.f30c0979.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.2.00.0810141647420.3288@nehalem.linux-foundation.org>
References: <20081015095916.f30c0979.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Oct 2008, Stephen Rothwell wrote:
>
> +#ifndef NO_IRQ
> +#define NO_IRQ	0
> +#endif

Btw, as to why not do this idiocy, just grep for it.

We have several drivers that try to do something this stupid. Don't take 
my word for it? Look for them. And see them do things like

 - drivers/scsi/arm/fas216.h:

	#ifndef NO_IRQ
	#define NO_IRQ 255
	#endif

 - drivers/pcmcia/pd6729.c (really interesting):

	#ifndef NO_IRQ
	#define NO_IRQ  ((unsigned int)(0))
	#endif

 - drivers/rtc/rtc-m48t59.c:

	#ifndef NO_IRQ
	#define NO_IRQ  (-1)
	#endif

so please don't add yet another version to the insanity. Just mark 
anything with NO_IRQ as BROKEN or ARM-specific, or something.

		Linus
