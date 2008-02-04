Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYBDAtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYBDAtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 19:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbYBDAtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 19:49:32 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:34336 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbYBDAtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 19:49:31 -0500
Message-ID: <47A66119.90702@kernel.org>
Date: Sun, 03 Feb 2008 16:49:29 -0800
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: =?UTF-8?B?SXNtYWlsIO+/vQ==?= <ismail@pardus.org.tr>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH] per-process securebits
References: <47A2D439.9050704@kernel.org> <47A558CF.60702@kernel.org> <20080202221812.2f9d70a8.akpm@linux-foundation.org> <200802030825.49221.ismail@pardus.org.tr>
In-Reply-To: <200802030825.49221.ismail@pardus.org.tr>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ismail � wrote:
| At Sunday 03 February 2008 around 08:18:12 Andrew Morton wrote:
|> So how do we ever get to the stage where we can recommend that
distributors
|> turn these things on, and have them agree with us?
|
| FWIW with my distributor hat on I think File system capabilities are
very nice
| and enables one to ship a distribution with a small set of setuid
binaries.
|
| On the other hand for per-process securebits, it would be nice to see a
| complete example how it could be applied to a setuid program. That
would be a
| nice step in moving forward.

Another way to put this is that there needs to be some application code
and documentation available to guide the way... Adding such things to
the example programs in libcap2 helped me find the 24-rc2 CAP_SETPCAP
bug and until I've gone through the task of testing all the bits
together, I won't believe the kernel support is anything other than
'experimental'.

Other folk are actively advocating and exploring this model. For
example, Chris Friedhoff has a page here that describes some first
steps for using filesystem capabilities:

~  http://www.friedhoff.org/posixfilecaps.html

His current discussion really focuses on using filesystem capabilities
as a straight substitute for setuid-0 bits on legacy applications. By
this I mean that the applications need to have fE != 0.

Right now, I am not aware (that could just be my ignorance!) of any
applications out there (besides the example progs in libcap2) that work
with filesystem capabilities in the way they are ultimately intended to
be used. For example, I'm confident that not many folk have tried this
sequence:

shell> ./getpcaps $$
Capabilities for `8598': = cap_setfcap+i
shell> cp /bin/ping .
shell> ls -l ./ping ./setcap
- -rwxr-xr-x  1 morgan morgan  36568 Feb  3 15:46 ./ping
- -rwxrwxr-x  1 morgan morgan 584851 Jan 30 23:24 ./setcap
shell> ./getcap -v ./ping ./setcap
./ping
./setcap = cap_setfcap+i
shell> ./setcap cap_net_raw=ep ./ping
shell> ./ping -c1 localhost
PING localhost.localdomain (127.0.0.1) 56(84) bytes of data.
64 bytes from localhost.localdomain (127.0.0.1): icmp_seq=0 ttl=64
time=0.049 ms
- --- localhost.localdomain ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.049/0.049/0.049/0.000 ms, pipe 2
shell>

Notice that I'm not root when executing any of these commands. Chris'
notes cover the last two commands (using sudo to finesse the earlier
bits) - but there is a dearth of admin specific info about the magic
used to get the first line to give the result I show here, and also a
lack of application-programing knowledge concerning what setcap does
internally to raise/lower its pE(cap_setfcap) capability.

[I'm confident that the securebits support will become important to
people after they are familiar with sequences like the one above, and
have a critical mass of applications that work that way.]

My guess is that somewhere in the 2.6.25-rcX sequence none of us who
have been working on it will want to keep the EXPERIMENTAL label any
longer. I'm not quite there yet - in all honesty its because I've not
quite tested it to my satisfaction...

More importantly I'm hopeful that in that time we'll have accumulated
enough documentation and user-space experience and examples to convince
others that this is, indeed, a viable feature to support in mainstream
distributions.

Cheers

Andrew

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFHpmEY+bHCR3gb8jsRAp3jAKCBSrnk8Q8Z0NQo9I2AwPH+aWwU2wCfYB/F
CxmiDUViWPh6LAK+YQqIh34=
=E/Ch
-----END PGP SIGNATURE-----
