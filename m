Return-Path: <linux-kernel-owner+w=401wt.eu-S934825AbXG2Th1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934825AbXG2Th1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 15:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932450AbXG2ThR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 15:37:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59664 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765832AbXG2ThQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 15:37:16 -0400
Date: Sun, 29 Jul 2007 20:37:04 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linux Kernel List <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [BUG] undefined reference to `kobject_actions'
Message-ID: <20070729193704.GA27994@flint.arm.linux.org.uk>
References: <20070729193401.GA18225@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729193401.GA18225@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 08:34:01PM +0100, Russell King wrote:
> Many ARM platforms fail to build with the following:
> 
> drivers/built-in.o: In function `store_uevent':
> hid-input.c:(.text+0x19c4c): undefined reference to `kobject_actions'
> 
> It appears that if hotplug is disabled, kobject_actions is ifdef'd
> away but hid-input still references it.

What I also meant to say is that it looks like it's caused by
commit 60a96a59569bab85571d0089682109bd3324e896.

Presumably if hotplug is disabled, we want store_uevent to be
removed as well?

(Also added Kay to the recipients.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
