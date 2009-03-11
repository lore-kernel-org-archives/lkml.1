Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140AbZCKQ6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbZCKQ6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZCKQ6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:58:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54926 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751009AbZCKQ6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:58:44 -0400
Date: Wed, 11 Mar 2009 16:58:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Timur Tabi <timur@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, rdreier@cisco.com, jirislaby@gmail.com,
       peterz@infradead.org, will.newton@gmail.com, hancockrwd@gmail.com,
       jeremy@goop.org
Subject: Re: [PATCH v4] introduce macro spin_event_timeout()
Message-ID: <20090311165806.0b6838ab@lxorguk.ukuu.org.uk>
In-Reply-To: <ed82fe3e0903110948w542a864dj821106900755f14e@mail.gmail.com>
References: <1236699004-1863-1-git-send-email-timur@freescale.com>
	<20090310153537.5fd5d84d@lxorguk.ukuu.org.uk>
	<1236729711.7086.28.camel@pasglop>
	<20090311003756.25ffa6f4@lxorguk.ukuu.org.uk>
	<ed82fe3e0903110948w542a864dj821106900755f14e@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are you talking about the udelay() inside the loop?  If so, I agree
> that this is bad and have removed it in the PowerPC-specific version:

The behaviour you want there is system specific - 10uS is a minimum
politeness value for x86 PCI bus for example.

> rdtsc instruction.  In this case, we're not adding arbitrary delays
> into the loop, and we're not using jiffies, but we are
> architecture-dependent.

and not useful

A macro of this form really needs to be able to look like

	spin_until_timeout(readb(foo) & 0x80, 30 * HZ) {
		udelay(10);
		/* Maybe do other stuff */
	}

to be more generally useful
