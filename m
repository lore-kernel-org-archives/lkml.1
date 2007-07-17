Return-Path: <linux-kernel-owner+w=401wt.eu-S935497AbXGQToo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935497AbXGQToo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760456AbXGQTof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:44:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50593 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759941AbXGQTof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:44:35 -0400
Date: Tue, 17 Jul 2007 12:44:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Fulghum <paulkf@microgate.com>
cc: James Simmons <jsimmons@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>
Subject: Re: [PATCH] Use tty_schedule in VT code.
In-Reply-To: <469D2810.9080109@microgate.com>
Message-ID: <alpine.LFD.0.999.0707171243220.27353@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org>
 <alpine.LFD.0.999.0707171222060.27353@woody.linux-foundation.org>
 <469D2810.9080109@microgate.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2007, Paul Fulghum wrote:
> 
> The scheduling is to move the processing out of interrupt context.
> The receive data is often extracted from the hardware
> at interrupt time and then queued for processing.

You misunderstand.

If the "delay" is zero, then why are you using "delayed" workqueues at 
all?

A delay of zero tends to be pointless. It's not a delay at all, and you 
could just use the regular NON-DELAYING workqueues.

		Linus
