Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbXLKNdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbXLKNdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 08:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbXLKNcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 08:32:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37629 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbXLKNcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 08:32:52 -0500
Date: Tue, 11 Dec 2007 14:32:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Newall <david@davidnewall.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       Rene Herman <rene.herman@keyaccess.nl>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <andi@firstfloor.org>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
Message-ID: <20071211133249.GA16750@one.firstfloor.org>
References: <20071207160439.71b7f46a@the-village.bc.nu> <20071209125458.GB4381@ucw.cz> <20071209165908.GA15910@one.firstfloor.org> <20071209212513.GC24284@elf.ucw.cz> <475CBDD7.5050602@keyaccess.nl> <m3bq8y23de.fsf@maximus.localdomain> <475DE37F.20706@davidnewall.com> <475DE6F4.80702@zytor.com> <475DEB23.1000304@davidnewall.com> <20071211131413.1079be59@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211131413.1079be59@the-village.bc.nu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The LPC bus behaviour is absolutely and precisely defined. The timing of
> the inb is defined in bus clocks which is perfect as the devices needing
> delay are running at a fraction of busclock usually busclock/2.
> 
> Older processors did not have a high precision timer so you couldn't
> calibrate loop based delays for 1uS.

For newer CPUs udelay() would be probably fine though. We seem
to have several documented examples now where the bus aborts
trigger hardware bugs, and it is always better to avoid such situations.

I still think the best strategy would be to switch based on TSC
availability. Perhaps move out*_p out of line to avoid code bloat.

-Andi

