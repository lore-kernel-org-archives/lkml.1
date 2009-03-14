Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbZCNWl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbZCNWl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 18:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbZCNWlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 18:41:49 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:41342 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbZCNWlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 18:41:49 -0400
Date: Sat, 14 Mar 2009 23:41:38 +0100
From: Jan Kasprzak <kas@fi.muni.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: MOXA I/O errors on 2.6.28+
Message-ID: <20090314224138.GC3375@fi.muni.cz>
References: <20090314213630.GA3375@fi.muni.cz> <20090314214230.352d293e@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090314214230.352d293e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.2i
X-Muni-Spam-TestIP: 147.251.48.3
X-Muni-Envelope-From: kas@fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sat, 14 Mar 2009 23:41:40 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
: On Sat, 14 Mar 2009 22:36:30 +0100
: Jan Kasprzak <kas@fi.muni.cz> wrote:
: 
: > I have several servers with MOXA C320 serial boards. Starting with 2.6.28,
: > some ports on MOXA boards sometimes get to a state where open("/dev/ttyMX<n>")
: > returns -EIO. I use the servers with MOXA boards as serial console hubs,
: > and I think the EIO state is caused by the remote getty or the whole remote
: > server being restarted.
: 
: Sounds like a refcount bug.
: 
: > 	2.6.27 is OK, 2.6.28 and 2.6.29-rc8 is faulty. I can git bisect
: > if you want (I have a spare server which I can reboot at will).
: 
: Might be useful but let me take a look first, chances are you've provided
: enough information

	It is this one:

d450b5a0196b6442cf3f29fc611d9c8daa56b559 tty: kref usage for isicom and moxa.

Reverting this commit on top of 2.6.29-rc8 (and resolving a single conflict
the revert introduces in drivers/char/moxa.c) makes the problem disappear. 

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
>>  If you find yourself arguing with Alan Cox, you’re _probably_ wrong.  <<
>>     --James Morris in "How and Why You Should Become a Kernel Hacker"  <<
