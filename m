Return-Path: <linux-kernel-owner+w=401wt.eu-S1422863AbXDXRpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422863AbXDXRpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422881AbXDXRpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:45:12 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:52399 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422863AbXDXRpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:45:10 -0400
Message-ID: <462E4223.1050109@trango-systems.com>
Date: Tue, 24 Apr 2007 19:45:07 +0200
From: LAPLACE Cyprien <cyprien.laplace@trango-systems.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: virtualization@lists.linux-foundation.org
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: SMP lockup in virtualized environment
X-Enigmail-Version: 0.94.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In a previous mail, Jeremy Fitzhardinge wrote:
> The softlockup watchdog is currently a nuisance in a virtual machine,
> since the whole system could have the CPU stolen from it for a long
> period of time.  While it would be unlikely for a guest domain to be
> denied timer interrupts for over 10s, it could happen and any
> softlockup message would be completely spurious.

I wonder how the guest domain can be denied timer interrupts for such a
long time ? The only reason I see is that the guest domain is not
scheduled at all (host domain or another higher priority guest running).

Now in SMP host and guest, what happens if a guest CPU is not scheduled
for a while ?

An example: in kernel/pid.c:alloc_pid(), if one of the guest CPUs is
descheduled when holding the pidmap_lock, what happens to the other
guest CPUs who want to alloc/free pids ? Are they blocked too ?


-- 
Cyprien Laplace

