Return-Path: <linux-kernel-owner+w=401wt.eu-S1759676AbXE0Urp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676AbXE0Urp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 16:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbXE0Urf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 16:47:35 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:60763
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbXE0Ure (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 16:47:34 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Subject: Re: b44: regression in 2.6.22 (resend)
Date: Sun, 27 May 2007 22:46:16 +0200
User-Agent: KMail/1.9.6
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jeff Garzik <jgarzik@pobox.com>, Gary Zambrano <zambrano@broadcom.com>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070525172431.60affaca@freepuppy> <200705272145.00796.mb@bu3sch.de> <200705272236.42628.maxi@daemonizer.de>
In-Reply-To: <200705272236.42628.maxi@daemonizer.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705272246.16960.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 May 2007 22:36:39 Maximilian Engelhardt wrote:
> When I ran 2.6.21.1 or 2.6.22-rc3 without any debugging tools just in normal 
> use I didn't notice any problems. It did work fine as I would expect it.
> I think the wget and ping tests here are as they should be.
> 
> With 2.6.22-rc2-mm1 I noticed that connections seem to be slower. The ping 
> test does confirm this, because here response times are very high. As far as 
> I can remember the wget download rate was a bit slower than 2.6.21.1 or 
> 2.6.22-rc3 till it stalled.
> I would expect it to be someting like the other two kernels. The two problems 
> I see are the high ping times and the fact that the card stopped working.
> 
> I don't know why the iperf results are so different from my personal 
> experience. I guess the fact that I get so bad results with 2.6.21.1 and 
> 2.6.22-rc3 is that iperf does something that causes the system to be 
> extremely slow and thus degrading performance. This could be a bug somewhere 
> in the b44 driver of 2.6.21.1 and 2.6.22-RC3 that has unintended been fixed 
> by the ssb switch, but that's only a roughly guess.

Ok. I guess (Yes I do :D) that there is an IRQ storm or something like that,
because you say that your system is becoming very slow and unresponsive.
It sounds like an IRQ is not ACKed correctly and so keeps triggering and
stalling the system. I'll take a look at a few diffs...
Do you see significant differences in the "hi" and/or "si" times in top?
Do you see a significant difference in the /proc/interrupts count. For
example that the kernel that works worse generates 10 times the IRQ count
for the same amount of data.

-- 
Greetings Michael.
