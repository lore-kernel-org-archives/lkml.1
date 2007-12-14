Return-Path: <linux-kernel-owner+w=401wt.eu-S1762768AbXLPBbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762768AbXLPBbz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 20:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbXLPBbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 20:31:48 -0500
Received: (root@vger.kernel.org) by vger.kernel.org id S1756631AbXLPBbs
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 20:31:48 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:52263 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbXLNUjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 15:39:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jZyQrnU2B5E4pWqdizt1iPjpO+ei85yrTVYfAXLzc4zO8dVNfpZZqK9JVMUm40vF3LAPPu/UhbhHhT2+uyeu1b9V3lwcJwFvmJISop/Q5odu7xUd/lrg5D2dC2WITTFJGUmfT2h+T6zRzhYFAS1Rc8oCjE7fGiw9b/vtLyTb8OI=
Message-ID: <83a51e120712141239u52d2dd68p1b6ee7ed08f2cecf@mail.gmail.com>
Date: Fri, 14 Dec 2007 15:39:14 -0500
From: "James Nichols" <jamesnichols3@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: After many hours all outbound connections get stuck in SYN_SENT
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a Java application that makes a large number of outbound
webservice calls over HTTP/TCP.  The hosts contacted are a fixed set
of about 2000 hosts and a web service call is made to each of them
approximately every 5 mintues by a pool of 200 Java threads.  Over
time, on average a percentage of these hosts are unreachable for one
reason or another, usually because they are on wireless cell phone
NICs, so there is a persistent count of sockets in the SYN_SENT state
in the range of about 60-80.  This is fine, as these failed connection
attempts eventually time out.

However, after approximately 38 hours of operation, all outbound
connection attempts get stuck in the SYN_SENT state.  It happens
instantaneously, where I go from the baseline of about 60-80 sockets
in SYN_SENT to a count of 200 (corresponding to the # of java threads
that make these calls).

When I stop and start the Java application, all the new outbound
connections still get stuck in SYN_SENT state.  During this time, I am
still able to SSH to the box and run wget to Google, cnn, etc, so the
problem appears to be specific to the hosts that I'm accessing via the
webservices.

For a long time, the only thing that would resolve this was rebooting
the entire machine.  Once I did this, the outbound connections could
be made succesfully.  However, very recently when I had once of these
incidents I disabled tcp_sack via:

echo "0" > /proc/sys/net/ipv4/tcp_sack

And the problem almost instanteaously resolved itself and outbound
connection attempts were succesful.  I hadn't attempted this before
because I assumed that if any of my network
equipment or remote hosts had a problem with SACK, that it would never
work.  In my case, it worked fine for about 38 hours before hitting a
wall where no outbound connections could be made.

I'm running kernel 2.6.18 on RedHat, but have had this problem occur
on earlier kernel versions (all 2.4 and 2.6).  I know a lot of people
will say it must be the firewall, but I've seen had this issue on
different router vendors, firewall vendors, different co-location
facilities, NICs, and several other variables.  I've totaly rebuilt
every piece of the archtiecture at one time or another and still see
this issue.  I've had this problem to varying degrees of severity for
the past 4 years or so.  Up until this point, the only thing other
than a complete machine restart that fixes the problem is disabling
tcp_sack.  When I disable it, the problem goes away almost
instantaneously.

Is there a kernel buffer or some data structure that tcp_sack uses
that gets filled up after an extended period of operation?
How can I debug this problem in the kernel to find out what the root cause is?

I've temporarily signed up on this list, but may opt-out if I can't
handle the traffic, so please CC me directly on any replies.

Thanks,
James Nichols
