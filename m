Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbYG1Sux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbYG1Sux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbYG1Suo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:50:44 -0400
Received: from jrmy.net ([64.40.111.128]:46354 "EHLO cowbell.omegasupeme.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753990AbYG1Sun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:50:43 -0400
X-Greylist: delayed 4037 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jul 2008 14:50:43 EDT
Message-ID: <488E051D.3020008@jrmy.net>
Date: Mon, 28 Jul 2008 10:42:53 -0700
From: Jeremy Freeman <jeremy@jrmy.net>
User-Agent: Thunderbird 2.0b2pre (Windows/20070122)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Ports 59873 - 60000 in use. Not sure by what.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: Spam detection software, running on the system "cowbell.omegasupeme.ca", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  I have exhausted all other avenues to solve this. So in a
	last ditch effort I am posting to KML. For some reason on one of my servers
	ports 59873 through 60000 are bound to some mystery process. netstat -nap
	shows nothing using them. lsof shows nothing using them. [...] 
	Content analysis details:   (-4.4 points, 4.5 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have exhausted all other avenues to solve this. So in a last ditch 
effort I am posting to KML.

For some reason on one of my servers ports 59873 through 60000 are bound 
to some mystery process.

netstat -nap shows nothing using them.
lsof shows nothing using them.

However they are most definitely in use.

I'll use nc for an example:

# nc -l 59872
.. works and listens ...

# nc -l 59873
nc: Address already in use

... < all ports in between> ...

# nc -l 60000
nc: Address already in use

nc -l 60001
.. works and listens ...

stracing nc shows:
bind(3, {sa_family=AF_INET, sin_port=htons(60000), 
sin_addr=inet_addr("0.0.0.0")}, 16) = -1 EADDRINUSE (Address already in use)

So the obvious culprit is a rootkit of some-sort. I checked the system 
using rkhunter and chkrootkit and they found nothing. Ran lsof, tcpdump 
and netstat from clean binaries on write-protected media.. also nothing. 
Further, this system has not been "on-net".. so although I am not 
disqualifying this as the issue, I cannot find any evidence.

I tried to run kstat but there does not seem to be a version for 2.6.

I tried changing my ip_local_port_range to 32768 - 55000 and the issue 
persists.

Even in run-level 1 those ports cannot be bound to.

BOX is: Red Hat Enterprise Linux Server release 5.1 (Tikanga)
Kernel: 2.6.18-53.1.14.el5 #1 SMP Tue Feb 19 07:18:46 EST 2008 x86_64 
x86_64 x86_64 GNU/Linux

All I can think is the kernel is somehow reserving these ports for 
outgoing use or something? Which I am not even sure about because I 
changed my ip_local_port_range to not include those ports and they are 
still held.

So.. now I am out of ideas.. perhaps someone out there can help me or 
give me some other ideas to try.

Thank you.

Please CC me if possible as I am not subscribed.

--
Jeremy
