Return-Path: <linux-kernel-owner+w=401wt.eu-S1760309AbXHTPdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760309AbXHTPdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 11:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbXHTPdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 11:33:25 -0400
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:1633 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756231AbXHTPdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 11:33:24 -0400
Date: Mon, 20 Aug 2007 17:34:50 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_SUSPEND and power consumption
Message-ID: <20070820173450.4ad178a9@hyperion.delvare>
In-Reply-To: <200708201211.34698.oliver@neukum.org>
References: <20070819153259.2c96b904@hyperion.delvare>
	<200708192242.43819.rjw@sisk.pl>
	<20070820120258.7d090cc4@hyperion.delvare>
	<200708201211.34698.oliver@neukum.org>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007 12:11:34 +0200, Oliver Neukum wrote:
> Am Montag 20 August 2007 schrieb Jean Delvare:
> > If I rmmod "ehci-hcd" then the power consumption is back to 69 W. This
> > confirms that this is really USB-related. I have to admit that I did
> > not expect an external drive to eat that much power from the system,
> > especially when not used. I am told that VIA chips are notoriously bad
> > at this kind of things. I'll try the same external drive on an Intel
> > system later today.
> > 
> > The last mystery remaining is how USB "activity" can cause my CPU to
> > heat. I would expect the south bridge to heat, not the CPU.
> 
> USB, or strictly speaking EHCI, OHCI and UHCI, use DMA. To allow
> that the cache coherency logic has to be active. Therefore your CPU
> cannot go to C3. Therefore it draws more power. The problem we are
> facing in USB is that to get great savings, our coverage has to be perfect.
> One device that cannot be autosuspended and we lose most savings.

Ah, OK, thanks for the clarification, it explains a lot.

I've made some more tests on two Intel boards and another VIA board.
The bottom line is that both VIA boards see a bump in power consumption
when plugging my USB 2.0 hard disk drive (10 W on one board, 4 W on the
other) while none of the Intel boards exhibit any change in power
consumption. I wonder if I should blame VIA for eating extra power when
the disk is plugged, or thank them for saving power when it's not. Or
maybe I am looking at things the wrong way, and I should thank AMD for
saving more power in C3 than Intel does?

-- 
Jean Delvare
