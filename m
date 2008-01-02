Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbYABN6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbYABN6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 08:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYABN6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 08:58:25 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52717 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752163AbYABN6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 08:58:25 -0500
Date: Wed, 2 Jan 2008 13:47:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: "David P. Reed" <dpreed@reed.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@gmail.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080102134738.2d4c7464@the-village.bc.nu>
In-Reply-To: <20080102100436.GB4389@elte.hu>
References: <47667366.7010405@gmail.com>
	<4766AE88.4080904@zytor.com>
	<4766D175.7040807@reed.com>
	<20071217212509.5edaa372@the-village.bc.nu>
	<477A634C.8040000@reed.com>
	<20080101161557.3ce2d5f8@the-village.bc.nu>
	<20080101164338.GA901@elte.hu>
	<20080101173212.1bba4939@the-village.bc.nu>
	<20080101184524.GA6655@elte.hu>
	<20080101210734.03414931@the-village.bc.nu>
	<20080102100436.GB4389@elte.hu>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ok, you are right. How about we go with one of your suggestions: rename 
> the API family to isa_*_p() in the affected ISA drivers? That makes it 
> perfectly clear that this is an ISA related historic quirk that we just 
> cannot properly emulate in an acceptable fashion. It will also make the 
> least amount of changes to these truly historic drivers.

Works for me. We need to build two versions of 8390.c now but thats no
big deal and sorts PCMCIA out too.

> The main maintenance thing we are interested in is to have no subsequent 
> new uses of this API and to eliminate these accesses from modern 
> hardware - and naming it clearly 'ISA' and making it dependent on 
> CONFIG_ISA would likely achieve that purpose.

Agreed - will see if EISA/VLB cases come up but thats trivial.

> oh, another thing: there are 100+ mails in this thread while there are 
> only 3 mails in the thread that lists 61 not-yet-fixed-in-2.6.24 
> regressions:

That would be because I'm trying to stop 100 new extra regressions ;)

Alan
