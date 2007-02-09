Return-Path: <linux-kernel-owner+w=401wt.eu-S2992834AbXBIUtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992834AbXBIUtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 15:49:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992831AbXBIUtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 15:49:09 -0500
Received: from gw.goop.org ([64.81.55.164]:32778 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992730AbXBIUtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 15:49:08 -0500
Message-ID: <45CCDE42.2050603@goop.org>
Date: Fri, 09 Feb 2007 12:49:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andi Kleen <ak@muc.de>, virtualization@lists.osdl.org,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH 1/10] lguest: Don't rely on last-linked fallthru when
 no paravirt handler
References: <1171012296.2718.26.camel@localhost.localdomain>	 <1171012458.2718.30.camel@localhost.localdomain>	 <200702091031.20249.ak@muc.de> <1171021966.2718.82.camel@localhost.localdomain>
In-Reply-To: <1171021966.2718.82.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> If we make it thought early_fault, this will do just that.
>
> Given this is a "never happens" situation, however... if you're actually
> under Xen or lguest, you won't make it that far (lguest, at least, will
> kill you on the cr2 load in early_fault, but it doesn't matter because
> we won't get anywhere with early_printk anyway).
>
> Actually, if we did BUG() here at least lguest would print something...
> I wonder what Xen would do...

Xen would print a complete register dump and backtrace.  There's not a
lot else you can do here; you could try early_printk, but if we're in a
strange virtual environment, there may be no device on which the output
could appear.

    J

