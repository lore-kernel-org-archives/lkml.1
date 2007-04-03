Return-Path: <linux-kernel-owner+w=401wt.eu-S1946035AbXDCX3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946035AbXDCX3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946034AbXDCX3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:29:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52074 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946035AbXDCX3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:29:18 -0400
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Woodhouse <dwmw2@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <17938.57292.870224.132415@cargo.ozlabs.ibm.com>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
	 <17938.57292.870224.132415@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 19:28:36 -0400
Message-Id: <1175642916.10567.24.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-7.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 09:14 +1000, Paul Mackerras wrote:
> Sigh.  I guess this is inevitable, but IMNSHO this exposes a weakness
> in our serial subsystem.
> 
> The problem is that this means that a user has to know "oh, the serial
> port on my computer is implemented with a Z85C30 chip, therefore it's
> /dev/ttyPZ0 not /dev/ttyS0, like it would be if the designers had used
> a 16C550".
> 
> Plus I'm sure this is going to mean that people using gui ppp dialers
> on powermacs will suddenly find that the gui can no longer find their
> serial port and they have no idea why.

> Why should a user know or care about that?  It really should be "it's
> the built-in serial port on my computer therefore it's /dev/ttyS0".

I agree to a certain extent -- but then again, why should a user know or
care about the name /dev/ttyS0 _either_? A GUI PPP dialer should be
listing the available serial ports in the system whatever their names
are.

And nobody _forces_ you to use the name ttyPZ0. If you really want, you
can call it ttyS0.... just mknod /dev/ttyS0 204 192

You could even have udev rules which share the /dev/ttyS$N namespace
between _all_ kinds of serial ports, if you really want to.

Abusing the 8250 device numbers prevents the 8250 module from being
loaded at the same time as pmac_zilog, and means you can't have both
internal port and PCMCIA or PCI 8250 ports active at the same time.
 
-- 
dwmw2

