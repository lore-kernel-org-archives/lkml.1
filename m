Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbZDDWYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbZDDWYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 18:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbZDDWYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 18:24:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:24025 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbZDDWYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 18:24:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=lKo37JrUxrNpE79HfgAJBq9JwSGV4AXxYjhNyL7Lb+kcJll4oUy8Uo7Rzx2qXr+v5+
         vJxhjVyVC40m1RqB3cPOOHes6lrJdm4Px8C5GrBnr922aVTVoxJJbZuDmWVGKCzuYhX5
         1gnqyiqgcboh3KUXaYIA4MZvQjadRhFHux6TI=
MIME-Version: 1.0
Date: Sat, 4 Apr 2009 16:24:21 -0600
Message-ID: <9b1675090904041524s67786e9ek45ad1292f6b4e219@mail.gmail.com>
Subject: Re: IO latency - a special case (futex hangs for an hour)
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's some more output.  I wasn't able to get vmstat going before it
happened this time, as it completely locked up the machine.  I hit
Ctrl-C several times, and eventually, after nearly an hour hanging on
futex, the Ctrl-C took effect, and killed it...

strace -T -e trace=futex -o strace3.txt mvn install
futex(0x7fff7f14ab1c, FUTEX_WAKE_PRIVATE, 1) = 0 <0.000016>
futex(0x7fff260d6a3c, FUTEX_WAKE_PRIVATE, 1) = 0 <0.000014>
futex(0x7f941dca310c, FUTEX_WAKE_PRIVATE, 2147483647) = 0 <0.000014>
futex(0x414169e0, FUTEX_WAIT, 27400, NULL) = ? ERESTARTSYS (To be
restarted) <3206.324673>
--- SIGINT (Interrupt) @ 0 (0) ---
futex(0x7f941d722f40, FUTEX_WAKE_PRIVATE, 1) = 1 <0.000030>
futex(0x414169e0, FUTEX_WAIT, 27400, NULL <unfinished ... exit status 130>

Yes, the kernel is well hung. :P

It appears to be similar to this guy's issue...
http://lkml.org/lkml/2004/10/3/35
