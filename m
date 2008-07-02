Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbYGBU5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbYGBU5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 16:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYGBU5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 16:57:14 -0400
Received: from averell.mail.tiscali.it ([213.205.33.55]:39537 "EHLO
	averell.mail.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbYGBU5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 16:57:13 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jul 2008 16:57:13 EDT
Date: Wed, 2 Jul 2008 22:51:10 +0200 (CEST)
From: Giacomo Mulas <gmulas@ca.astro.it>
Reply-To: Giacomo Mulas <gmulas@ca.astro.it>
To: linux-kernel@vger.kernel.org
cc: debian-kernel@lists.debian.org
Subject: b43 locks the machine when resuming after suspend to disk
Message-ID: <alpine.DEB.1.10.0807021830300.32045@capitanata.ca.astro.it>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried searching on the list for this, before posting, but searching the
mailing list archives with keywords such as b43, suspend, resume... brings
up such a ludicrous amount of threads that it's not realistic to check them
all, so just tell me what to look for if it's been asked already.

Whenever I do a suspend to disk after using b43, the computer freezes hard
as soon as it attempts again to access b43 after resume.

Minimal how to reproduce the freeze:
1) modprobe b43
2) hibernate (using any suspend to disk, which one is irrelevant)
3) resume
4) ifconfig wlan0 up

This has been happening (at least) since b43 was included in the mainline
kernel, on my Asus A6K laptop running an x86_64 kernel (now the latest
2.6.25 stable release or compiled from the latest released debian sid
sources). The nvidia module is not responsible: I explicitely booted my
laptop in single user mode without any unnecessary modules, same result. It
does not happen using the windows driver with ndiswrapper (which I would
prefer to avoid for other reasons), so it definitely depends on b43 or
something it depends on. Unloading and reloading the b43 module and all the
other modules it depends on does not change anything. Just loading the
module once, hibernating and resuming means freeze-up as soon as the module
is actually initialised next time, regardless of it having been unloaded and
reloaded any number of times before or after the suspend-resume cycle. No
oopses, nothing on system logs, just instant freeze-up. Is there some
testing a user can do to help nailing this? I am not a kernel developer,
even if I am a decent C programmer.

Please CC me on replies, I am not on the list.

Thanks in advance,
Giacomo Mulas

-- 
_________________________________________________________________

Giacomo Mulas <gmulas@ca.astro.it>
_________________________________________________________________

OSSERVATORIO ASTRONOMICO DI CAGLIARI
Str. 54, Loc. Poggio dei Pini * 09012 Capoterra (CA)

Tel. (OAC): +39 070 71180 248     Fax : +39 070 71180 222
Tel. (UNICA): +39 070 675 4916
_________________________________________________________________

"When the storms are raging around you, stay right where you are"
                          (Freddy Mercury)
_________________________________________________________________
