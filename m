Return-Path: <linux-kernel-owner+w=401wt.eu-S1946026AbXDCXO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946026AbXDCXO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946028AbXDCXO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:14:28 -0400
Received: from ozlabs.org ([203.10.76.45]:51311 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946026AbXDCXO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:14:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17938.57292.870224.132415@cargo.ozlabs.ibm.com>
Date: Wed, 4 Apr 2007 09:14:20 +1000
From: Paul Mackerras <paulus@samba.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
In-Reply-To: <1175610345.2665.15.camel@shinybook.infradead.org>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse writes:

> There are proper device numbers registered for pmac_zilog now. Use them.

Sigh.  I guess this is inevitable, but IMNSHO this exposes a weakness
in our serial subsystem.

The problem is that this means that a user has to know "oh, the serial
port on my computer is implemented with a Z85C30 chip, therefore it's
/dev/ttyPZ0 not /dev/ttyS0, like it would be if the designers had used
a 16C550".

Plus I'm sure this is going to mean that people using gui ppp dialers
on powermacs will suddenly find that the gui can no longer find their
serial port and they have no idea why.

Why should a user know or care about that?  It really should be "it's
the built-in serial port on my computer therefore it's /dev/ttyS0".

Paul.
