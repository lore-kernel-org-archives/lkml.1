Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYBRBUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYBRBUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 20:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbYBRBUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 20:20:25 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:53941 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbYBRBUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 20:20:24 -0500
Message-ID: <47B8DD55.5070800@kernel.org>
Date: Sun, 17 Feb 2008 17:20:21 -0800
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: charles.kirsch@internet.lu, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Gerald Combs <gerald@wireshark.org>,
       Gilbert Ramirez <gram@alumni.rice.edu>, Guy Harris <guy@alum.mit.edu>
Subject: Re: Possible problem in linux file posix capabilities
References: <20080217224851.GA9168@sergelap.austin.ibm.com>
In-Reply-To: <20080217224851.GA9168@sergelap.austin.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge E. Hallyn wrote:
| Andrew, this pretty much was bound to happen...  we need to figure out
| what our approach here should be.  My preference is still to allow
| signals when p->uid==current->uid so long as !SECURE_NOROOT.  Then as
| people start using secure_noroot process trees they at least must know
| what they're asking for.

I don't think there is anything special about root.

I've been trying to advocate that we remove the *uid == 0 part of this
check since we discussed it in November:

As I said 11/29/07 [Re: [patch 31/55] file capabilities: don't prevent
signaling	setuid root programs]:
| I actually said (11/26/07):
|> >> Serge,
|> >>
|> >> I still feel a bit uneasy about this. Looking ahead, with filesystem
|> >> capabilities, one can simulate this same situation with a setuid
|> >> 'non-root' program as follows:
|> >>
|> >> [... example of simulating the same situation with setuid-non-root
...]
|> >>
|> >> Is there a compelling reason to include the euid==0 check?

So, independent of whether SECURE_NOROOT is in effect or not, I think
this particular line should simply read:

~        if (p->uid == current->uid)
~                 return 0;

| An alternative stance is to accept these things as they come up and try
| to quickly work with the authors of such programs to work around it.  I
| suppose in a security sense that's the superior way :)  But it also
| seems likely to lead to most people choosing option 2 above and not
| bothering to fix the problem.

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFHuN1V+bHCR3gb8jsRAkqnAJ9o9j9KALm/LxWRoU9PGo9f7UWNYgCdGTQC
Pm0daaJRMhWzcGSsTNgqj44=
=EkD2
-----END PGP SIGNATURE-----
