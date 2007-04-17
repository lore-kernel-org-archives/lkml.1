Return-Path: <linux-kernel-owner+w=401wt.eu-S1161023AbXDQTsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161023AbXDQTsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 15:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161001AbXDQTsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 15:48:06 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:22214 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031186AbXDQTsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 15:48:05 -0400
Message-ID: <46252471.2030006@tls.msk.ru>
Date: Tue, 17 Apr 2007 23:48:01 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Wondering: why capabilities system is broken?
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully not a flamewar question...

Currently, capabilities of a process are reset during exec()
system call.  At least effective+permitted set.

1) In case new uid != 0, all the caps are cleared, so it is not
possible to execute a program as non-root but still give it some
capabilities (like, say, CAP_NET_BIND_SERVICE).

2) In case new uid == 0, effective and permitted sets are restored
to all-ones.

This is regardless of other settings, like prctl(KEEPCAPS), or
the current set of capabilities.

I partly understand why 2) is done - in case of setuid binary being
executed, all the capabilities are set for it.  But this breaks
executing non-setuid binaries too -- for example, it'd be very nice
to be able to chroot to some directory, and remove CAP_SYS_CHROOT
(and other evil caps like CAP_SYS_MODULE, CAP_SETPCAP) -- this way,
with minimal efforts, chroot will work almost (yes, I understand
it's not entirely the same) the same as BSD jail(2) concept.

So the question is: why capability sets are being reinitialized during
exec()?  At least in 2.4 era, they weren't...  and stuff like
execcap, sucaps etc was working.  Now they aren't anymore.

Thanks.

/mjt
