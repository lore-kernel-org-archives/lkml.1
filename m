Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZCNWaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZCNWaM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 18:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbZCNW37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 18:29:59 -0400
Received: from rankki.sonarnerd.net ([83.145.240.118]:14834 "EHLO
	mail.sonarnerd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbZCNW37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 18:29:59 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Mar 2009 18:29:58 EDT
Message-ID: <49BC2D93.8090507@sonarnerd.net>
Date: Sun, 15 Mar 2009 00:20:03 +0200
From: Jussi Laako <jussi@sonarnerd.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: HPET mmap() problem
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In the JACK audio connection kit we have support for mmap() of /dev/hpet
as our time source (as one of the possibilities). However, there's a
nasty issue with the current driver as it reserves one of the three
comparator-timers per each open() and denies further opens when the
timers are exhausted. And in case it's already used as a system clock
source, two of the timers are already reserved...

However, we are only interested on the main counter value, and would
like to have unlimited access from number of processes to this value
through mmap() of the device.

Any ideas/recommendations/suggestions on which way to change the driver
to support this? Or even better, if someone is already working on this?


Best regards,

	- Jussi
