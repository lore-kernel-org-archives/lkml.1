Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbZDVVKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbZDVVKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 17:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZDVVK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 17:10:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47358 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752596AbZDVVK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 17:10:27 -0400
Date: Wed, 22 Apr 2009 22:08:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David VomLehn <dvomlehn@cisco.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jamie Lokier <jamie@shareable.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090422220853.0af12ece@lxorguk.ukuu.org.uk>
In-Reply-To: <20090422205427.GA28435@cuplxvomd02.corp.sa.net>
References: <20090421230849.GA29555@cuplxvomd02.corp.sa.net>
	<Pine.LNX.4.44L0.0904221111320.3405-100000@iolanthe.rowland.org>
	<20090422205427.GA28435@cuplxvomd02.corp.sa.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Alright, I know you (Alan (Stern)) know about USB. I think someone else
> mentioned Firewire. What other hotpluggable buses do we need to worry about
> and how can we get them interested?

In theory any console can be hot pluggable - PCI-X hotplug video cards,
hotplug serial ports. In fact right now bad things occur if you
hot-unplug consoles.

> 2.	All devices have been probed
> If we exit for reason 2, it means that no such device is present,
> and we go on to the do the appropriate thing for that device class.

USB has no notion of #2 really

> Yes, I think we absolutely exclude devices plugged in after boot. I think such
> usage, if it needs to be supported, can be handled with hot plugging. I'm a
> little squishy on whether we might to be able to hot plug USB consoles as I
> have a request to support this, but I think it's a separate issue from
> supporting hot pluggable boot devices and I'm not worrying about it now.

This still assumes you can tell the difference, but USB in particular is
rather like undergraduate students - they turn up when they feel like it
at some point after they get kicked into life.

I don't think that is a big problem because our bus model is basically
that all devices are discovered asynchronously (increasingly so with
Arjan's speed up patches). A console model therefore has to deal with
console addition and removal being dynamic.
