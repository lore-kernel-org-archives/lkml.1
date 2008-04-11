Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbYDKNU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbYDKNU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 09:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYDKNUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 09:20:20 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37962 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752765AbYDKNUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 09:20:19 -0400
X-Sasl-enc: 1fSgNwb0787MKYakCYfuXVZqr/5+UYLtOsqCP/y+kzzR 1207920016
Message-ID: <47FF658E.2040808@ladisch.de>
Date: Fri, 11 Apr 2008 15:20:14 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Dimitri Gorokhovik <dimitri.gorokhovik@leacom.fr>
CC: tglx@linutronix.de, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] HPET: register additional counter-only char device
References: <1207904307.13216.15.camel@laphroaig>
In-Reply-To: <1207904307.13216.15.camel@laphroaig>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitri Gorokhovik wrote:
> I need to have many processes all reading from userspace the counter register
> of the (same) HPET hardware. Just reading counter values, not handling timers,
> enabling/disabling interrupts etc. `/dev/hpet' doesn't allow for this, as the
> number of times it can be opened is limited by the number of timers available.

Indeed.  The driver assumes that userspace wants to program its own
timer (like an RTC device).  Allowing mmap() on the hardware counter was
more an afterthought.

> What would be the right way to implement such a support? For now, I simply
> register a new misc device, '/dev/hpetctr', along with '/dev/hpet', for the same
> ACPI device and on the same occasion.

Your patch circumvents CONFIG_HPET_MMAP.

Another possibility would be to allow the device to be opened
infinitely many times but not to allocate a hardware timer until one of
the ioctls is called.  This means that opening /dev/hpet does not
guarantee that a timer is available, but this has already been possible
previously because request_irq() might fail.


Regards,
Clemens
