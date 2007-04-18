Return-Path: <linux-kernel-owner+w=401wt.eu-S1422673AbXDRJRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422673AbXDRJRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 05:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXDRJRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 05:17:11 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41477 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751690AbXDRJRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 05:17:09 -0400
Date: Wed, 18 Apr 2007 10:20:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: minyard@acm.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
Subject: Re: [PATCH] Provide better abstraction for the serial drivers to
 xmit buf and tty
Message-ID: <20070418102027.0e1edb2b@the-village.bc.nu>
In-Reply-To: <20070418045423.GA12136@localdomain>
References: <20070418045423.GA12136@localdomain>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The basic reason for all this is to eventually allow the low-level
> serial drivers to function without a uart_info structure being
> allocated.  This will allow the serial console, debuggers like kgdb,
> and the IPMI serial driver to use one interface to the uart code and

Its cheaper to allocate a uart_info that keep doing all the checks, at
least for port->info. I can see why you want to avoid port->info->tty as
a debugger can end up running before the tty layer and that would be hard
to work around.

For the other macros - the macros are more efficient than the equivalent
inline code generation at least for some gccs.

Do you really need any of this change but to check info->tty ?

Alan

