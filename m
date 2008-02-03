Return-Path: <linux-kernel-owner+w=401wt.eu-S935898AbYBCGCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935898AbYBCGCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 01:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbYBCGBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 01:01:54 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:58402 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbYBCGBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 01:01:53 -0500
Message-ID: <47A558CF.60702@kernel.org>
Date: Sat, 02 Feb 2008 22:01:51 -0800
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH] per-process securebits
References: <47A2D439.9050704@kernel.org> <20080201002837.d84fc029.akpm@linux-foundation.org>
In-Reply-To: <20080201002837.d84fc029.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
| On Fri, 01 Feb 2008 00:11:37 -0800 "Andrew G. Morgan"
<morgan@kernel.org> wrote:
|
|> [This patch represents a no-op unless CONFIG_SECURITY_FILE_CAPABILITIES
|>  is enabled at configure time.]
|
| Patches like this scare the pants off me.

Nice to know I'm not being mediocre! :-D

| I'd have to recommend that distributors not enable this feature (if we
| merge it) until they have 100% convinced themselves that it is 100%
| correct.

FWIW I'm in complete agreement if you are referring to
CONFIG_SECURITY_FILE_CAPABILITIES and not just this patch...

As to the rest, the short version:

* The sendmail thing was a subtle problem trying to map setuid(non-0)
into a capability framework. The long and the short of it was that an
unprivileged user could prevent a privileged application from exercising
all of the privilege it needed and getting root access as a result.

* I'm saying setuid(0) apps will most definitely continue to be
supported by a kernel even with CONFIG_SECURITY_FILE_CAPABILITIES=y. All
the patch does is make it possible for a capable(CAP_SETPCAP) process to
declare itself as the parent of a process tree in which that is not the
case.

Here is the very very long version (which took some time to write, and I
thought was a bit much to spam these lists with):

http://userweb.kernel.org/~morgan/sendmail-capabilities-war-story.html

Cheers

Andrew

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFHpVjP+bHCR3gb8jsRAsMtAJ9XqR0yaeY8O3F8/nCdoALPksKZOQCg06/7
pJOZRfMORnI8YfIcta5nVLw=
=Rpj4
-----END PGP SIGNATURE-----
