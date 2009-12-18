Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbZLRJTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbZLRJTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 04:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZLRJTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 04:19:39 -0500
Received: from quamquam.org ([88.198.196.3]:34194 "EHLO quamquam.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbZLRJTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 04:19:37 -0500
Message-ID: <4B2B491D.2010201@poelzi.org>
Date: Fri, 18 Dec 2009 10:19:25 +0100
From: Daniel Poelzleithner <poelzi@poelzi.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bryan Donlan <bdonlan@gmail.com>
CC: linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
       Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
Subject: Re: Suggestion: xtime as new inode attribute
References: <4B292D9A.5060501@poelzi.org> <3e8340490912162306m4236569s4e497ad01409c756@mail.gmail.com>
In-Reply-To: <3e8340490912162306m4236569s4e497ad01409c756@mail.gmail.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=0A7B003D;
	url=http://files.poelzi.org/poelzi.asc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 92.117.35.193
X-SA-Exim-Rcpt-To: bdonlan@gmail.com, linux-kernel@vger.kernel.org, horms@verge.net.au, jeffrey.hundstad@mnsu.edu
X-SA-Exim-Mail-From: poelzi@poelzi.org
X-SA-Exim-Scanned: No (on quamquam.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Bryan Donlan wrote:

> Why isn't atime sufficient? atime is updated when programs are
> executed, and it's uncommon for executable files to be accessed
> without being executed; for the purposes of determining whether a
> program is needed, it ought to be good enough.

Why atime is not useable is for example that full system backup would
distroy all data. Thinking about grepping for a string in /usr or
/usr/bin because you are searching for something will update all atime
stamps and therefore cause dataloss for this purpose.

> Note that many modern distros use relatime to reduce the (significant)
> overhead of atime; this may account for why you may not be seeing
> atime update for executables; try mounting with -o strictatime if you
> want to see it at work, but beware, as this will bring with it a major
> performance hit - which your proposal would as well :)

The performance impact is one reason of course. As executing is much
more seldom the impact of updating the xtime should be mild enough that
it could be done by default. I don't mount strictatime for this reason, too.

kindly regards
 Daniel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJLK0kdAAoJEFYpgV2Roepc35AP/RkT6Q0Nz0qseGboEFYOfwju
NDsyJT2Thw/bm/zwo024TwnyoBOA2o9rGwmIuppsOGijpyuSSwJXVUcnPXoC/Gto
Eb3eMud41qZewFgIRNkur7torWG2k59GmY9AgmKgYbm8L1O81k6Zeesl3aY0SedJ
gF690R7Ktn+Cb+9xMq3g2ip8Vu7TegHHS0L9UtD0zaVRlmqBf1cfZBWpKZJ1ndyG
15/pUBdYoIJavMxgRAbpcpSZfBEJlW1kJpELeIyBCglYkh8j2W5mJVi0PcwUtEzp
cdgVNjQwpqUicYsY7WbG469m2jd7oPl6hCKPJ1oWncaVUyddubU9JHYRAAgTYvMT
fBb/83yxQ6H9DFfwHk7dRGLrko8vhZ3GiDJIYmbWbR5XHa+qr4lwoX1M3NTAp62B
j15hy0Ap2cu58tFhMFoh9pOPY95b5Xs7hVlBcqm2CqSwIOcmO/3f8Vmw1RLlG/F+
0XZ692nmYFPrnKqQAM6mQXuKUI4QGPLlaD2lSyZf3czXD1kTt01SQSvZ7stI3aA5
hEgYDm+zJHR76W6Wr5JXISQMSCLOiYf5g0gRLF2TIXz5VL2W3NOex+vCnBoEPmXt
hQ6t3x1YWrhE35VV2r4zhxUz+/9wGEncGGOwwdBPmegVW/NrxAwjsa7hPdddG5+4
V9RsTox7UQNQYaxk3PpR
=ixfn
-----END PGP SIGNATURE-----
