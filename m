Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbZCNVgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbZCNVgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 17:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbZCNVgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:36:36 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:34182 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbZCNVgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:36:35 -0400
Date: Sat, 14 Mar 2009 22:36:30 +0100
From: Jan Kasprzak <kas@fi.muni.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: MOXA I/O errors on 2.6.28+
Message-ID: <20090314213630.GA3375@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.2i
X-Muni-Spam-TestIP: 147.251.48.3
X-Muni-Envelope-From: kas@fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sat, 14 Mar 2009 22:36:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello,

I have several servers with MOXA C320 serial boards. Starting with 2.6.28,
some ports on MOXA boards sometimes get to a state where open("/dev/ttyMX<n>")
returns -EIO. I use the servers with MOXA boards as serial console hubs,
and I think the EIO state is caused by the remote getty or the whole remote
server being restarted.

	After getting EIO, this particular port always returns EIO, until
the server is rebooted. The moxa module usage count is non-zero (even when
nobody has the board open), so reloading just the moxa.ko module is not
possible.

	2.6.27 is OK, 2.6.28 and 2.6.29-rc8 is faulty. I can git bisect
if you want (I have a spare server which I can reboot at will).

	My MOXA boards are

01:08.0 Serial controller: Moxa Technologies Co Ltd Intellio C320 Turbo PCI (rev 02)

	What can I do to have this problem fixed? Thanks,

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
>>  If you find yourself arguing with Alan Cox, you’re _probably_ wrong.  <<
>>     --James Morris in "How and Why You Should Become a Kernel Hacker"  <<
