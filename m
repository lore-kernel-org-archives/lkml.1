Return-Path: <linux-kernel-owner+w=401wt.eu-S1764780AbXF1Pu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764780AbXF1Pu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759101AbXF1PuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:50:21 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:54103 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080AbXF1PuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:50:19 -0400
Message-ID: <4683D8B5.1060809@kernel.org>
Date: Thu, 28 Jun 2007 08:50:13 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: "Serge E. Hallyn" <serue@us.ibm.com>, "Serge E. Hallyn" <serge@hallyn.com>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: implement-file-posix-capabilities.patch
References: <924812.95310.qm@web36611.mail.mud.yahoo.com>
In-Reply-To: <924812.95310.qm@web36611.mail.mud.yahoo.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Casey Schaufler wrote:
>> The only reason for having an fE bitmap is to allow a capability-aware
>> program (you really trust to do its privileged operations carefully) to
>> be lazy and get some of its capabilities raised for free. Perhaps you
>> can clarify why this is a desirable thing? :-)
> 
> No, it's to allow you to grant a subset of the available capabilities
> to a program that is not aware of capabilities. You can give "date"
> the capability to reset the clock without giving it the capability
> to remove other people's files without changing the code or running
> it setuid.

This is precisely what fE = 0 or ~0 provides.

Recall, an exec()'d program gets its p*' capabilities from a convolution
of its exec()er's inheritable set (pI) *and* the file's capabilities
(fI,fP,fE):

    pI' = pI
    pP' = (X & fP) | (pI & fI)
    pE' = pP' & fE

[Linux essentially has cap_bset for X.]

The fine-grain ability for ping to do its thing without becoming
powerful enough to load a kernel module, for example, is facilitated by
the "pP' &" part of the derivation of pE' (and not simply the unfiltered
value of fE!).

As I said before, either the program knows how to raise and lower bits
in its pE set, or it doesn't. In the former case, fE=0. In the latter
case, fE=~0 will ensure that it gets all of the capabilities it is
permitted to exercise at time of execution.

Could you cite some examples of where this position is unreasonable?

Thanks

Andrew

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGg9i1+bHCR3gb8jsRAvViAJ9T5x1fHrLGF4niRq7VhRqg4sej3wCgxkom
oAFQEQwLkd/D6J5gi7Fb3Ww=
=+ZLb
-----END PGP SIGNATURE-----
