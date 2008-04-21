Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbYDUAoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbYDUAoe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 20:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYDUAo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 20:44:26 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:43737 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbYDUAo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 20:44:26 -0400
Message-ID: <480BE354.408@kernel.org>
Date: Sun, 20 Apr 2008 17:44:04 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: serge@hallyn.com, David <david@unsolicited.net>
CC: casey@schaufler-ca.com, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25 Kernel - Problems with capabilities
References: <46016.36939.qm@web36608.mail.mud.yahoo.com> <480B7D72.7020503@unsolicited.net> <20080421000055.GA17510@vino.hallyn.com>
In-Reply-To: <20080421000055.GA17510@vino.hallyn.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

serge@hallyn.com wrote:
| Quoting David (david@unsolicited.net):
|> Casey Schaufler wrote:
|>> Do you have a libcap that reflects the change from 32 capabilities
|>> to 64? You'll be looking for libcap.so.2.06 or thereabouts.
|>>
|> Adding libcap-2.08 and recompiling ntpd has fixed the issue, and I'm now
|> running normally, thanks!
|
| I don't understand why, though.  Looking at the ntpd code (ntp-4.2.4p4)
| it just does a cap_set_proc(cap_from_text("X=epi"));  It should simply
| be sending in the _LINUX_CAPABILITY_VERSION which shipped with libcap,
| which should have been _V1, and the kernel should honor that so long as
| you didn't try to send in caps > 31, which ntpd wasn't.
|
|> Was this userspace visible change planned in advance for 2.6.25 ? ...
as I
|> guess a few other people with venerable old userspace components may
come
|> across this issue.
|>
|> Cheers
|> David
|
| It's been in the works a long time and we thought we'd done pretty
| well with backward compatibility.  I really don't see why you had
| that failure!

I'm confused (and somewhat concerned) about this too. 32-bit capability
apps should act fine. The only thing you might notice is a strange
comment about it in /var/log/messages.

David, can you run strace on the failing program (configuration)?

[I'll see if I can read the complete thread on one of the archives and
see if anything else sticks out.]

Thanks

Andrew

|
| Do you know which version of libcap you had before?
|
| thanks,
| -serge
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIC+NP+bHCR3gb8jsRAjunAKDXe/fDfwIJWi6wgtpdxZefbRq5SACffb1+
pQNi1C/8PPGWYpUXFxizUuI=
=LHl0
-----END PGP SIGNATURE-----
