Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbYJEBb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbYJEBb1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 21:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbYJEBbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 21:31:19 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:45299 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbYJEBbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 21:31:18 -0400
Message-ID: <48E818C0.3080109@kernel.org>
Date: Sat, 04 Oct 2008 18:30:40 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, selinux@tycho.nsa.gov
Subject: Re: [PATCH] capability: WARN when invalid capability is requested
 rather than BUG/panic
References: <1222782946.28251.63.camel@localhost.localdomain> <alpine.LRH.1.10.0810010008130.2068@tundra.namei.org> <1222785389.28251.83.camel@localhost.localdomain> <20080930153820.GA28616@us.ibm.com> <1222790843.28251.92.camel@localhost.localdomain> <20080930162830.GB31779@us.ibm.com>
In-Reply-To: <20080930162830.GB31779@us.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge E. Hallyn wrote:
> Andrew Morgan, any opinions?

[Sorry to get to this late.]

I'd prefer:

3) BUG_ON(!cap_valid(flag)) (garbage in BUG out, no panic)

It seems absurd to be guessing what a buggy driver might be wanting -
open source or not.

>> idea of mutating the inputs and then making the security decision based
>> on that mutation rather than on the original inputs (and yes, I realize
>> that exactly what 2.6.24 was doing)

and let's call it another bug fixed.

>>> Though I still think it's not unreasonable to simply ask for the driver
>>> to be fixed.
>> I'm not going to argue that the driver needs fixed and that is the real
>> problem.  I know its been filed with them and the response was that
>> there is no support for linux.  I have today tried to poke the path I
>> know of between Red Hat and them to ask them to take a look.

if distributions want to silently work around it (with some sort of
variant of 4 or perhaps 2) until the vendor of this driver has time to
fix it, then that doesn't seem unreasonable. But it seems to me that the
upstream kernel shouldn't institutionalize this sort of nonsense.

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFI6Bi9+bHCR3gb8jsRArIBAKCuODkju29dCosHWPiXZVKoNP0FSwCaAzPx
EWihO1+F0qd0BFZarm/CFKM=
=HJik
-----END PGP SIGNATURE-----
