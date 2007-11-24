Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbXKXGJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbXKXGJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 01:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbXKXGJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 01:09:18 -0500
Received: from twinlark.arctic.org ([207.29.250.54]:35097 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbXKXGJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 01:09:17 -0500
Message-ID: <4747C003.3070709@kernel.org>
Date: Fri, 23 Nov 2007 22:09:07 -0800
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: Stephen Smalley <sds@tycho.nsa.gov>, "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org, darwish.07@gmail.com,
       jmorris@namei.org, method@manicmethod.com, paul.moore@hp.com,
       LSM List <linux-security-module@vger.kernel.org>
Subject: Re: + smack-version-11c-simplified-mandatory-access-control-kernel.patch
 added to -mm tree
References: <335711.34116.qm@web36610.mail.mud.yahoo.com>
In-Reply-To: <335711.34116.qm@web36610.mail.mud.yahoo.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I believe it was you who once eloquently observed that, at its heart,
the POSIX (sic) capabilities model was all about providing a mechanism
for overriding the prevailing security policy (be it MAC or DAC or
whatever) in a defined way.

Casey Schaufler wrote:
> Now I know that there are lots of people who don't share my
> views on granularity, but I have lots of experiance with this
> and the cases where it actually makes sense to break the MAC
> capabilities up are rare.
> 
> That's my going in position, at any rate. I'm always open to
> finding out why I'm wrong.

Its not so much why you are wrong, as being clear that we're not using a
generic name and inadvertently limiting ourselves to a SMACK-like model...

It feels to me as if a MAC "override capability" is, if true to its
name, extra to the MAC model; any MAC model that needs an 'override' to
function seems under-specified... SELinux clearly feels no need for one,
and browsing through your SMACK patch, there are many instances where
this capability is used as an convenience privileged override. However,
in other situations, it appears as if the capability is required for
basic SMACK operations to succeed.

My sense is that there is a case to be made for: CAP_MAC_ADMIN and
CAP_MAC_OVERRIDE here. The former being for cases where SMACK (or
whatever MAC supports it) requires privilege to perform a privileged MAC
operation, and the latter for saying "OK, I'm without a paddle but need
one" (or words to that effect).

Cheers

Andrew

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHR8AA+bHCR3gb8jsRAqY/AJsGI56TDQyBD42LCovpJTYHkaL0pQCdHM5S
kk5v2O4ohY2O0z93JNdKVBY=
=dbQn
-----END PGP SIGNATURE-----
