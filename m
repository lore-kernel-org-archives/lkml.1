Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbZCPKHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbZCPKHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZCPKHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:07:36 -0400
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:35665 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbZCPKHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:07:35 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Mar 2009 06:07:35 EDT
Message-ID: <49BE2365.2070708@ladisch.de>
Date: Mon, 16 Mar 2009 11:01:09 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Jussi Laako <jussi@sonarnerd.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: HPET mmap() problem
References: <49BC2D93.8090507@sonarnerd.net>
In-Reply-To: <49BC2D93.8090507@sonarnerd.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jussi Laako wrote:
> In the JACK audio connection kit we have support for mmap() of /dev/hpet
> as our time source (as one of the possibilities). However, there's a
> nasty issue with the current driver as it reserves one of the three
> comparator-timers per each open() and denies further opens when the
> timers are exhausted. And in case it's already used as a system clock
> source, two of the timers are already reserved...
> 
> However, we are only interested on the main counter value, and would
> like to have unlimited access from number of processes to this value
> through mmap() of the device.
> 
> Any ideas/recommendations/suggestions on which way to change the driver
> to support this?

Don't allocate a hpet_dev in hpet_open but when hpet_ioctl is called for
the first time.

> Or even better, if someone is already working on this?

I'm planning to work on this.


HTH
Clemens
