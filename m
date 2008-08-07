Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbYHGX2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbYHGX2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 19:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYHGX2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 19:28:36 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:35833 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbYHGX2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 19:28:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=jPui+Jswz5GD8ZrQ1yKwAeZIpHNh/E56PCp+W1nIFHhz4vWazlsiUBvBuoIwuorj/r
         3DSgq2mVG5DxvkzD4YD+kDiVmzSIy2HLtnQatLC7QZQ4PNhyVVqADF80YXOF4tH0Bfax
         sB0gLkemhgu78r+OXXmjfaeFsRSXdbrrfEuKY=
Date: Fri, 8 Aug 2008 02:28:20 +0300
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, matthew@wil.cx, jbarnes@virtuousgeek.org
Subject: T60p not coming out of suspend to RAM since 2.6.27-rc1
Message-ID: <20080807232819.GA7984@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In both 2.6.27-rc1 and 2.6.27-rc2, my laptop won't come out of
suspend to ram: it blinks the crescent one or twice,
and hangs. It does resume fine under 2.6.26.

I bisected the problem and got the following commit:

commit ce6fce4295ba727b36fdc73040e444bd1aae64cd
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Fri Jul 25 15:42:58 2008 -0600

    PCI MSI: Don't disable MSIs if the mask bit isn't supported

    David Vrabel has a device which generates an interrupt storm on the INTx
    pin if we disable MSI interrupts altogether.  Masking interrupts is only
    a performance optimisation, so we can ignore the request to mask the
    interrupt.

    Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Reverting ce6fce4295ba727b36fdc73040e444bd1aae64cd
fixes resume from suspend to RAM for me.

Steps to reproduce:

Press Fn-F4 to suspend, press Fn to resume.
This works on 2.6.26, hangs on vanilla 2.6.27-rc1
and 2.6.27-rc2, works on 2.6.27-rc2 with reverted ce6fce..

Bug added to bugzilla: http://bugzilla.kernel.org/show_bug.cgi?id=11283

-- 
MST
