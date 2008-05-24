Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbYEXEkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbYEXEkz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 00:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYEXEkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 00:40:46 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:38713 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbYEXEkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 00:40:45 -0400
Message-ID: <48379C48.5020802@kernel.org>
Date: Fri, 23 May 2008 21:40:40 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, bojan@rexursive.com,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: Re: capget() overflows buffers.
References: <20080522140402.GB2071@codemonkey.org.uk> <20080522175744.GE4018@sequoia.sous-sol.org> <20080522205341.GA30402@sequoia.sous-sol.org> <4835F929.7010200@kernel.org> <20080522233757.GD30402@sequoia.sous-sol.org> <48366D9A.70806@kernel.org> <20080523182602.GO30402@sequoia.sous-sol.org> <48375B10.10003@kernel.org> <20080524010923.GT30402@sequoia.sous-sol.org>
In-Reply-To: <20080524010923.GT30402@sequoia.sous-sol.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Chris Wright wrote:
| Hmm, it would be kind of nice to have a formalized way get the size,
| perhaps it would help with KaiGai's request for caps printed out.
| Something that tells us either the number of u32s, or the max bit
| supported?

Serge has already provided one  with the call,

~   sys_prctl(PR_CAPBSET_READ, x);

returns -EINVAL if (x > max-supported-capability).

(Ref: 3b7391de67da515c91f48aa371de77cb6cc5c07e)

|> | All looks good.  I think we need to issue some warnings, because
|> | at least Fedora 9 and openSUSE 11 are/will be 2.6.25 based.
|>
|> Do any of the above answers help? (FWIW I attached the patch to the
|> redhat bug.)
|
| Yes, thanks.  But I still think we need to print a warning (unfortunately
| we can't distinguish libcap from non-libcap app), because apps that
| aren't using libcap should really be updated (either pull new update
| from vendor or recompiled by end user).

Just to be clear, you are not referring to a warning that the
application is stuck in a 32-bit capability world, because we already
have one of those: warn_legacy_capability_use(). You are referring to a
warning that might indicate a problem with code like that given in your
example - in which case I'll respond to that part of the thread...

Cheers

Andrew

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFIN5xI+bHCR3gb8jsRAsz6AKDHOeOO8953r2bRJ3RXZaRdBnlGUwCdG3oX
CvWy/iQVmfVdpeRIWLa7N/w=
=R7Bq
-----END PGP SIGNATURE-----
