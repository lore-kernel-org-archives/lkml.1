Return-Path: <linux-kernel-owner+w=401wt.eu-S964822AbXBLJaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964822AbXBLJaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964821AbXBLJaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:30:39 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:50119 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964822AbXBLJai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:30:38 -0500
From: Stefan Rompf <stefan@loplof.de>
To: linux-kernel@vger.kernel.org
Subject: Open reiserfs transactions (was Re: 2.6.19-rc5: grub is much slower resuming from suspend-to-disk than in 2.6.18)
User-Agent: KMail/1.9.1
Cc: arvidjaar@mail.ru
MIME-Version: 1.0
Content-Disposition: inline
Date: Mon, 12 Feb 2007 10:34:08 +0100
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <200702121034.08647.stefan@loplof.de>
X-RZG-AUTH: kR2YrGeU3i5IZ7e/KoXXySNh16uouyfpvuAE9NRyohxnu02OuGTTkbe6PwRfQq/rApUg
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:

> This is rather funny; in 2.6.19-rc5 grub is *really* slow loading kernel
> when I switch on the system after suspend to disk. Actually, after kernel
> has been loaded, the whole resuming (up to the point I have usable desktop
> again) takes about three time less than the process of loading kernel +
> initrd. During loading disk LED is constantly lit. This almost looks like
> kernel leaves HDD in some strange state, although I always assumed HDD/IDE
> is completely reinitialized in this case.

I have the same problem since I made my desktop computer able to suspend 
again. As others in this thread said, grub replays all open transactions 
internally before accessing a file on an unclean reiserfs partition.

>From some tests, 2.6.19(.x) seems to keep quite a bunch of open transactions 
even if I do multiple syncs just before a hard reset or echo 
>/proc/acpi/sleep on an idle system. I haven't verified against 2.6.18 yet, 
but there have been some non cosmetical reiserfs updates in 2.6.19. Anyone 
aware of a change that may cause this behaviour?

Stefan
