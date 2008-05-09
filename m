Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbYEIJtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbYEIJtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 05:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYEIJt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 05:49:26 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:40991 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbYEIJtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 05:49:24 -0400
Date: Fri, 9 May 2008 11:49:22 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com
Subject: Swapping in 2.6.26-rc1 oddities (but it is omnipresent bug)
Message-ID: <20080509094922.GJ31771@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 09 May 2008 11:49:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I noticed that doing backup with rsync on my laptop from a local disk to a usb
disk swaps out many processes. To advice of Jiri Slaby (cc:), I did some
vmstat dumps.

More precisely, I run:
i=0; while true; do cat /proc/vmstat > vmstat.$i; sleep 3; i=$[$i+1]; done

and in parallel, I run the rsync to make the backup.

The vmstats can be found here:
http://www.fi.muni.cz/~xhejtman/vmstat/
(tar ball included at the end).

Jiri stated that the kernel begins to swap (somewhere around vmstat.50) even
if there are 70000 free pages.

Any ideas?

It more likely starts to swap the applications if I do not touch the laptop
(actively using Firefox or something like).

Also, the memory is occupied by disk caches not by the applications, so
I think it should not be swapped.

Moreover:
$ cat /proc/sys/vm/swappiness 
0

$ cat /proc/sys/vm/dirty_writeback_centisecs 
499

-- 
Luká¹ Hejtmánek
