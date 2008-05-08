Return-Path: <linux-kernel-owner+w=401wt.eu-S1762534AbYEHKlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762534AbYEHKlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 06:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756477AbYEHKk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 06:40:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:36229 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756163AbYEHKk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 06:40:57 -0400
X-Authenticated: #34473864
X-Provags-ID: V01U2FsdGVkX18oTIkWQsUokKMDFjMrKQsMESmn6e/WyjHXNroUTH
	niUpyxwjP9hjDu
Message-ID: <4822D8B6.4090008@gmx.de>
Date: Thu, 08 May 2008 12:40:54 +0200
From: Philipp Kohlbecher <xt28@gmx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>
Subject: clocksources: order of preference
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why is the TSC preferred to the HPET as a clocksource for the x86 
architecture?

"Understanding the Linux Kernel" states that the HPET is preferable to 
the TSC due to its richer architecture. Up to version 2.6.17.14, 
arch/i386/kernel/timers/timer.c also contained a comment to that effect 
and accordingly ranked the HPET before the TSC.

This was changed when the new clocksource infrastructure was introduced 
with version 2.6.18. (The HPET clocksource received a rating of 250; the 
TSC, 300.)

Preferring the TSC leads to problems when it is unstable. While this can 
be prevented by setting CONFIG_X86_TSC, certain distribution kernels 
(striving for compatibility) don't, resulting in soft lockups.

Are there better reasons to prefer the TSC or may I submit a patch that 
swaps the respective ratings?

Thanks for reading,
- Philipp Kohlbecher

Please CC me, I am not on the list.
