Return-Path: <linux-kernel-owner+w=401wt.eu-S936925AbXLQXOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936925AbXLQXOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762876AbXLQXOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:14:36 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:56404 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762261AbXLQXOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:14:34 -0500
Date: Tue, 18 Dec 2007 00:14:33 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: James Nichols <jamesnichols3@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: After many hours all outbound connections get stuck in SYN_SENT
In-Reply-To: <83a51e120712141239u52d2dd68p1b6ee7ed08f2cecf@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0712180009390.32270@fbirervta.pbzchgretzou.qr>
References: <83a51e120712141239u52d2dd68p1b6ee7ed08f2cecf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 14 2007 15:39, James Nichols wrote:
>
>However, after approximately 38 hours of operation, all outbound
>connection attempts get stuck in the SYN_SENT state.  It happens
>instantaneously, where I go from the baseline of about 60-80 sockets
>in SYN_SENT to a count of 200 (corresponding to the # of java threads
>that make these calls).
>
>When I stop and start the Java application, all the new outbound
-               ^

at that point, try tcpdump. It may, or may not, show something.

>connections still get stuck in SYN_SENT state.
>During this time, I am still able to SSH to the box

Try uploading something through rsync+ssh, or scp+ssh. If it aborts
or hangs after a while, that may be an strong indication of a crappy
router. Also, I'd advise to upgrade to something newer like >=
2.6.22. There was one of those SACK-broken routers around here too,
but it seemed to have been replaced (or linux got a mysterious fix
:-) as one day when I tried turning off SACK, rsync didnot abort
anymore on new connections.

Though, if SACK was the problem, the problem would be much more
likely to appear after the handshake. YMMV.


>and run wget to Google, cnn, etc, so the
>problem appears to be specific to the hosts that I'm accessing via the
>webservices.
>
>For a long time, the only thing that would resolve this was rebooting
>the entire machine.  Once I did this, the outbound connections could
>be made succesfully.  However, very recently when I had once of these
>incidents I disabled tcp_sack via:
>
>echo "0" > /proc/sys/net/ipv4/tcp_sack
>
>And the problem almost instanteaously resolved itself and outbound
>connection attempts were succesful.  I hadn't attempted this before
>because I assumed that if any of my network
>equipment or remote hosts had a problem with SACK, that it would never
>work.  In my case, it worked fine for about 38 hours before hitting a
>wall where no outbound connections could be made.
>
>I'm running kernel 2.6.18 on RedHat, but have had this problem occur
>on earlier kernel versions (all 2.4 and 2.6).
