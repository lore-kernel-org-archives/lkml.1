Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbYLFVK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbYLFVK2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 16:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYLFVKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 16:10:16 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53986 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752749AbYLFVKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 16:10:15 -0500
Date: Sat, 6 Dec 2008 21:09:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 1/3] PCI: Rework default handling of suspend and resume
Message-ID: <20081206210927.445f0bc6@lxorguk.ukuu.org.uk>
In-Reply-To: <200812061843.59495.rjw@sisk.pl>
References: <200812020320.31876.rjw@sisk.pl>
	<200812061822.35763.rjw@sisk.pl>
	<alpine.LFD.2.00.0812060930490.3425@nehalem.linux-foundation.org>
	<200812061843.59495.rjw@sisk.pl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> prefer it to go next.  After it's been merged, I'm going to add the mandatory
> suspend-resume things (save state and go to a low power state on suspend,
> restore state on resume) to the new framework in a separete patch.
> 
> Is this plan acceptable?

I have at least two drivers I look after where if you put the device into
D3 you lost. We survive because on a successful suspend/resume sequence
the BIOS puts it back coming out of suspend but that means we must not
put those devices into D3 ourselves ever - including during a suspend
before we are 100% comitted to the suspend completing or reboot.
