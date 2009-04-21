Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbZDUNfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbZDUNfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbZDUNfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:35:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:44113 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbZDUNfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:35:11 -0400
Date: Tue, 21 Apr 2009 06:35:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David VomLehn <dvomlehn@cisco.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090421063549.3b71881d@infradead.org>
In-Reply-To: <20090421064346.GB8020@elte.hu>
References: <20090420234006.GA1958@cuplxvomd02.corp.sa.net>
	<20090421064346.GB8020@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009 08:43:46 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> The proper approach would be to use one of the async_synchronize*() 
> facilities in kernel/async.c to properly order the opening of the 
> console with device init.

Unfortunately this is not the answer.

First of all, USB does not use the async_* infrastructure, so it does
not do anything.
But more importantly... USB *CANNOT* do this fundamental operation.
USB does not have the capability to know when you have seen all devices
that are connected. Devices just show up a random amount of time after
you turn the power on for the bus.... there's no "and now we've seen
all" operation.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
