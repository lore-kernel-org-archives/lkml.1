Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbYGWHou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbYGWHou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 03:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYGWHol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 03:44:41 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:60066 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750793AbYGWHol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 03:44:41 -0400
X-Sasl-enc: pVbckYbAwa/6ni6gMQjkDwbw/XveMkGC7AMSBd3zPks1 1216799080
Message-ID: <4886E164.2070304@ladisch.de>
Date: Wed, 23 Jul 2008 09:44:36 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: lkml <linux-kernel@vger.kernel.org>, bob.picco@hp.com,
       venkatesh.pallipadi@intel.com, Vojtech Pavlik <vojtech@suse.cz>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [patch 2.6.26] /dev/hpet - fixes and cleanup
References: <200807221508.56672.david-b@pacbell.net>
In-Reply-To: <200807221508.56672.david-b@pacbell.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
>   * Tighten and correct the userspace interface code
>       ...
>       + only open comparators that have an interrupt, and can thus
>         perform "real work"

This prevents userspace applications from doing mmap() on /dev/hpet
even if there is no interrupt.

This seems to be the only part of the userspace interface that is
used in practice.  Because of the availability of POSIX timers, it might
make sense to deprecate the HPET ioctl interface.

> And re that kernel interface:  IMO, worth having a relatively
> generic interface for hardware timers instead of inventing a new
> interface for each new bit of hardware.

AFAIK it was intended to be similar to the RTC callback interface, but
that was before the generic high-precision timer stuff was introduced.


Regards,
Clemens
