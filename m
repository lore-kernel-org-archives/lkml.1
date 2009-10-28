Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbZJ1N0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbZJ1N0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 09:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbZJ1N0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 09:26:20 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49589 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbZJ1N0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 09:26:19 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Leonidas ." <leonidas137@gmail.com>, Chris Friesen <cfriesen@nortel.com>,
       Noah Watkins <noah@noahdesu.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Difference between atomic operations and memory barriers
In-Reply-To: Your message of "Wed, 28 Oct 2009 12:00:05 +0200."
             <4AE81625.5000500@panasas.com>
From: Valdis.Kletnieks@vt.edu
References: <f22d86810910261019yc77dbf0sa7688a98e7b98267@mail.gmail.com> <7ADB5FD7-9C97-4987-BC20-997258B25FD2@noahdesu.com> <f22d86810910261122j6c9e57e8pd4a257090f65c727@mail.gmail.com> <4AE5F04E.3050908@nortel.com> <f22d86810910261200n130fda06r46fdbcc808195002@mail.gmail.com> <45208.1256644303@turing-police.cc.vt.edu>
            <4AE81625.5000500@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1256736377_2776P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 28 Oct 2009 09:26:17 -0400
Message-ID: <36159.1256736377@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.34.98 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4AE8467A.0358,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1256736377_2776P
Content-Type: text/plain; charset=us-ascii

On Wed, 28 Oct 2009 12:00:05 +0200, Boaz Harrosh said:

> What don't you know? the CPU that started it all was like that, the x86 16-bit
> "large" and "huge" model had a double register seg:offset set, also in-memory
> was double-ints(2*16) even the i386 was running 16 bit modes for a long time.

Yes, but there were instructions to load segment registers, and those were
atomic, and there were instructions to compute effective addresses based on the
segment registers, and those were basically atomic. But you never had a chance
to see a partly loaded segment register (just like in today's virtual memory
equivalents, a PTE's effect is basically atomic - you never see half the
address bits of a PTE take effect and not the other half).

Yes, if a segment register wasn't set right, you'd load/store from the wrong
place in memory (we *still* have that, playing with %fs and %gs).  But that's
different than an actual load or store only half-happening, or happening partly
to an old place and partly to a new one, because a segment register is only
half-finished laoding.


--==_Exmh_1256736377_2776P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK6EZ5cC3lWbTT17ARAsOnAJ0V8POCw3yu9K/xKmmnwAt49NdjFQCgs+pF
JJHtfv/0NUs4qMLQAqzv4EU=
=adak
-----END PGP SIGNATURE-----

--==_Exmh_1256736377_2776P--

