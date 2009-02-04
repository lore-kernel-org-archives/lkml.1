Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbZBDCtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbZBDCtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 21:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZBDCtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 21:49:32 -0500
Received: from gate.crashing.org ([63.228.1.57]:59817 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbZBDCtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 21:49:31 -0500
Subject: Re: [PATCH 1/7] PCI PM: Fix handling of devices without drivers
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Eric Sesterhenn <snakebyte@gmx.de>
In-Reply-To: <alpine.LFD.2.00.0902031815550.3247@localhost.localdomain>
References: <200902040154.36018.rjw@sisk.pl>
	 <200902040156.15200.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902031815550.3247@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 13:49:15 +1100
Message-Id: <1233715755.16867.149.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 18:23 -0800, Linus Torvalds wrote:
> Whaa? This is basically totally obfuscated code both in the caller _and_ 
> in the callee.
> 
> Now, it looks like this all then goes away in PATCH 7/7, so I guess I 
> shouldn't complain too much, but I just don't see much point in carrying 
> this broken patch around in the series, since it's then going away and 
> rewritten almost immediately again.
> 
> Apart from that complaints, Acked-by: for the series. 

Same comments. It took me a while to figure the logic out, which I end
up agreeing with but the code is pretty obfuscated ... And yes, patch 7
seems to improve things, but then, that makes reading the patch itself
nearly impossible :-) I ended up patching the file and -then- reading
it.

I tried the whole thing on various powerbooks, along with some patches
I'm about to send for radeonfb, atyfb and aty128fb to make them properly
call pci_save_state() before they hand-change the D state, and things
appear to be working fine. (well, appart from some unrelated problems
leading to some might_sleep() hits but as I said, they are unrelated to
this series)

I need a couple more tests of the fbdev patches on some machine variants
and once done, I'll post them out. Hopefully tonight.

Cheers,
Ben.


