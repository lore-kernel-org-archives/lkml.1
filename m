Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbYFHWfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbYFHWfY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 18:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbYFHWfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 18:35:13 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:45190 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbYFHWfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 18:35:12 -0400
Message-ID: <484C5E84.2020307@kernel.org>
Date: Sun, 08 Jun 2008 15:34:44 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ linus-git ] prctl(PR_SET_KEEPCAPS, ...) is broken for some
 configs, e.g. CONFIG_SECURITY_SELINUX
References: <1212932321.4675.9.camel@earth>	<484BF662.9070100@kernel.org> <20080608110630.08a45cc6.akpm@linux-foundation.org>
In-Reply-To: <20080608110630.08a45cc6.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

What do people think about comment #8 from Stephen Smalley?:

The dummy module is generally in the untenable position of having to lie
to userspace or break the existing capability-related system call
interface.  It should just go away, and make capability the default
module (w/ stubs for the rest of the LSM hooks as with dummy).  Then
CONFIG_SECURITY=n will yield the same result as CONFIG_SECURITY=y w/o
any further options.

Cheers

Andrew

Andrew Morton wrote:
| On Sun, 08 Jun 2008 08:10:26 -0700 Andrew Morgan <morgan@kernel.org>
wrote:
|
|> Nacked-by: Andrew G. Morgan <morgan@kernel.org>
|>
|> In a configuration in which you are not using capabilities, what is the
|> "keep capabilities" operation supposed to do? Lie to you?
|>
|> http://bugzilla.kernel.org/show_bug.cgi?id=10748
|
| I totally agree with comment 11 there. Quite a number of people have
already
| hit this and more surely will.  How can we help them (and hence us)?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFITF6D+bHCR3gb8jsRAlLKAKCjwR7JthL+7+EOWEHzGXv1XptfPACgvT0v
n9WeEJNiuVp0usx1EzKkT8A=
=/D3k
-----END PGP SIGNATURE-----
