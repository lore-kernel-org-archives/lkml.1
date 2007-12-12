Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbXLLNQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbXLLNQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 08:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXLLNQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 08:16:51 -0500
Received: from a.mx.secunet.com ([213.68.205.161]:43343 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbXLLNQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 08:16:50 -0500
X-Greylist: delayed 1631 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Dec 2007 08:16:50 EST
Message-ID: <475FD8E0.5030009@secunet.com>
Date: Wed, 12 Dec 2007 13:49:36 +0100
From: Thomas Egerer <thomas.Egerer@secunet.com>
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ip_rt_bug weirdness
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2007 12:49:37.0631 (UTC) FILETIME=[74370EF0:01C83CBD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: RIPEMD160

Hello *,

maybe it's my bad. Most probably! Even in that case I'd need someone to
point out the mistake to me!
I'm currently (trying) to write a transparent proxy application, using
libipq to capture packets + iptables' redirect mechanism.
The basic idea works as follows:
+---+      +---+      +---+
| S |<---->| P |<---->| D |
+---+ (1)  +---+  (2) +---+

(1) uses iptables' REDIRECT target; the received data is then forwarded,
    using another socket connection (2)
(2) uses libipq to do some kind of SNAT and change the local source
    address to S's address and vice versa for the incoming packets
    from D

So far the theory. The application works fine, as long, as I do not
remap the source port (destination port, respectively) from P to D. Once
I enable the port remapping I get syslog messages like the following:
[ 7742.939471] ip_rt_bug: [S' IP] -> [P's IP at (2)], ?
and a reset from P towards D, using exactly all the correct TCP
settings, except for the destination port, that is 1, sometimes 2, or 3.
I couldn't figure out, why.
By the way, the three-way-handshake works fine, the RSTs are generated
for the first packet to contain a TCP-payload. Also netstat tells me,
there is an established connection between P and D, but somehow (I
assume that this might be the trouble) looking for the corresponding
socket connection on P fails.
I'm totally puzzled why that happens. libipq reinjects the packets with
properly changed checksums and whatnot, yet the RSTs are generated.
I've also tried NF_REPEAT, instead of the NF_ACCEPT verdict. The
behavior remains identically.

Any ideas, anyone?

Thanks in advance

Thomas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHX9jgUGqFG0l5Kr0RAyKTAJ9qempDK//O0TrCwXgXzpdjBhW+QwCeJnUQ
udz08rqnHoFvkFF6q7a2C2s=
=DZhp
-----END PGP SIGNATURE-----
