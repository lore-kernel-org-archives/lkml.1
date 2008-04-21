Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbYDULLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbYDULLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 07:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbYDULLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 07:11:16 -0400
Received: from smtp.seznam.cz ([77.75.72.43]:46004 "HELO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753956AbYDULLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 07:11:15 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Apr 2008 07:11:15 EDT
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: linux-kernel@vger.kernel.org
Date: Mon, 21 Apr 2008 13:12:41 +0200
MIME-Version: 1.0
Subject: What pokes the ISA IO port of 0x211 ?
Message-ID: <480C92C9.18283.A24BB91B@localhost>
X-mailer: Pegasus Mail for Windows (4.21c)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Smtpd: 1.0.36@12969
X-Seznam-User: frantisek.rysanek@post.cz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Everyone,

I'm dealing with an embedded PC motherboard that contains some custom 
circuitry (GPIO), accessible via an ISA IO range between 0x200 and 
0x218.  

There's an interesting issue with this in recent Linux (tried 
2.6.22.6 and 2.6.24.2): something probes IO port 0x211 on boot, which 
happens to be an add-on buzzer control port - effectively the kernel 
boot launches an accoustic alarm :-)  

Any ideas what this could be? 

Obviously it's no problem for me to write a tiny kernel module to 
disable the alarm again, and I've actually verified the problem using 
ioperm()+outb() from user space, but still I'd be interested to know 
which particular piece of code could be probing that address...

The address decode might be implemented using some general-purpose 
features of the Winbond W83627HF SuperIO (as there's no ISA in the 
system, just ICH4 LPC) - but it seems quite unlikely that this would 
be caused by something fiddling with the W83627 config registers.
It really seems like something writes 0xFF to IO port 0x211.

Thanks for your time and attention :-)

Frank Rysanek

