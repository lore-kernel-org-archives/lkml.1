Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbXFYUed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbXFYUed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbXFYUeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:34:24 -0400
Received: from lixom.net ([66.141.50.11]:42119 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbXFYUeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:34:23 -0400
Date: Mon, 25 Jun 2007 15:43:41 -0500
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linuxppc-dev@ozlabs.org,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH v2] pcmcia: CompactFlash driver for PA Semi Electra boards
Message-ID: <20070625204341.GA8865@lixom.net>
References: <20070625010311.GA31355@lixom.net> <20070625171221.GA6684@lixom.net> <20070625193909.GA26021@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625193909.GA26021@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 08:39:09PM +0100, Christoph Hellwig wrote:
> On Mon, Jun 25, 2007 at 12:12:21PM -0500, Olof Johansson wrote:
> > Driver for the CompactFlash slot on the PA Semi Electra eval board. It's
> > a simple device sitting on localbus, with interrupts and detect/voltage
> > control over GPIO.
> > 
> > The driver is implemented as an of_platform driver, and adds localbus
> > as a bus being probed by the of_platform framework.
> 
> Looks good to me. The only odd thing is the inconsistant use of
> #ifdef CONFIG_PCMCIA in setup.c.

Thanks, and thanks for the review.

The ifdef is needed since for CONFIG_PCMCIA=n builds, the bus notifier
isn't available. I wanted to do the bus notifier registration explicitly
before the of_platform bus probe to avoid later surprises due to reordered
initcalls in case it was split up in it's own initcall.

I could add the code under ifdef as well, but it didn't seem too
critical. Once the second major board comes along I'll probably move it
out to a per-board file, there's no real need for it just yet.


-Olof

