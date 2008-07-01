Return-Path: <linux-kernel-owner+w=401wt.eu-S1761678AbYGAVzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761678AbYGAVzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761485AbYGAVzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:55:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761441AbYGAVzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:55:33 -0400
Date: Tue, 1 Jul 2008 14:49:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: dhowells@redhat.com, serue@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/4] security: filesystem capabilities bugfix1
Message-Id: <20080701144941.f72e27f5.akpm@linux-foundation.org>
In-Reply-To: <48635799.3010500@kernel.org>
References: <48635799.3010500@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

grumbles.

On Thu, 26 Jun 2008 01:47:21 -0700
"Andrew G. Morgan" <morgan@kernel.org> wrote:

> Subject: [PATCH 1/4] security: filesystem capabilities bugfix1

"bugfix1" is not exactly a high-quality description of this change. 
Please put more thought into the patch titles.  I cooked up something
randomly sensible-looking for these changes.

> Date: Thu, 26 Jun 2008 01:47:21 -0700
> User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Bugfix for the fragile setuid fixup code in the case that filesystem
> capabilities are supported.
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.2.6 (GNU/Linux)
> 
> iD8DBQFIY1eZ+bHCR3gb8jsRAgneAJ4jvnswg0+5Rkr69YFbFYXexK8vNQCgnAS7
> jF5ZqrBAAtU7RNVHia18ODk=
> =cOzB
> -----END PGP SIGNATURE-----

Would much prefer that the above gobbledygook not be there, please.  It
causes me to go through a spectacular number of manual steps to be able
to extricate the diff, and it makes it hard to reply to the diff when
commenting on it.

Plain old text/plain with an inlined patch is much more user-friendly.

And the PGP signing doesn't gain us anything because I'd cheerfully
apply a patch from a faked "Andrew Morgan" anyway.  I'd expect the
real Andrew Morgan to squawk when he sees me apply a patch which he
didn't send.

<clicks on attachments, right-clicks, does save-as to a temp file,
reads the temp file back in, does s/^/^> /g)

> +	if (!issecure(SECURE_NO_SETUID_FIXUP)) {
> +		(void) cap_set_effective(old_cap);
> +	}

The unneeded braces and void cast are not in the preferred style.  I
zapped them.
