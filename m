Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbZDUOkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbZDUOkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZDUOju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:39:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50222 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751083AbZDUOjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:39:49 -0400
Date: Tue, 21 Apr 2009 15:37:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jamie Lokier <jamie@shareable.org>, Arjan van de Ven <arjan@infradead.org>,
       David VomLehn <dvomlehn@cisco.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090421153745.2d8964c7@lxorguk.ukuu.org.uk>
In-Reply-To: <20090421142627.GA18129@elte.hu>
References: <20090420234006.GA1958@cuplxvomd02.corp.sa.net>
	<20090421064346.GB8020@elte.hu>
	<20090421063549.3b71881d@infradead.org>
	<20090421135034.GA30114@elte.hu>
	<20090421140533.GA6375@shareable.org>
	<20090421142627.GA18129@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +config PRINTK_CONSOLE_WAIT
> +       int "Default number of milliseconds to wait for console device"
> +       default 1000
> 
> Does this only delay init during a console-less bootup - or are 
> there other later apps that might trigger the delay?

The console proper needs to be event based not timeout hacks. Can we
please fix this stuff properly ? To start with there is no reason that the
USB console can't implement a "maybe we have hardware, maybe I buffer 64K
until it shows up" behaviour and bind to hardware as and when USB serial
devices get inserted. We do much of this for the VT drivers so we save
messages before PCI and fb come up.

The timeout wait proposed is also wrong I agree. Take a timestamp at the
point we are ready to mount the root fs, any delays on root mount, console
appearance etc should then be tested against this timestamp not as delays
versus some undefined later event.

Alan
