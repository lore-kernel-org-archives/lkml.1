Return-Path: <linux-kernel-owner+w=401wt.eu-S1759580AbYLLSh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbYLLSh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 13:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758384AbYLLShu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 13:37:50 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:39181 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758063AbYLLSht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 13:37:49 -0500
Date: Fri, 12 Dec 2008 19:38:10 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: 2.6.28-rc8 big regression in VM
Message-ID: <20081212183810.GA4390@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 12 Dec 2008 19:37:47 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I noticed that in the current git head, the VM subsystem contains a serious
bug - cached memory is newer freed:

# free; echo 3 > /proc/sys/vm/drop_caches; free
             total       used       free     shared    buffers     cached
Mem:       2016688     669172    1347516          0       2160     335120
-/+ buffers/cache:     331892    1684796
Swap:      1542232          0    1542232
             total       used       free     shared    buffers     cached
Mem:       2016688     659336    1357352          0        320     327288
-/+ buffers/cache:     331728    1684960
Swap:      1542232          0    1542232

the above sequence has been done on completly idle system so there is no
reason for non freeing the cache.

once the whole memory is eaten by the cache, the system is pretty unusable.

-- 
Luká¹ Hejtmánek
