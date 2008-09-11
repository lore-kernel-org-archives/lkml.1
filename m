Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbYIKOhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbYIKOhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 10:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYIKOg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 10:36:57 -0400
Received: from mail.suse.de ([195.135.220.2]:37602 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbYIKOg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 10:36:56 -0400
Message-ID: <48C92CFE.2030803@suse.com>
Date: Thu, 11 Sep 2008 10:36:46 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Jeff Mahoney <jeffm@suse.com>,
       Faidon Liambotis <paravoid@debian.org>,
       David Miller <davem@davemloft.net>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
References: <48C68507.6000609@suse.com> <1221087719.13621.50.camel@macbook.infradead.org> <20080910.160505.14060698.davem@davemloft.net> <48C8BC17.5050508@debian.org> <48C8C580.5020803@suse.com> <20080911133847.GD5082@mit.edu>
In-Reply-To: <20080911133847.GD5082@mit.edu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Theodore Tso wrote:
> On Thu, Sep 11, 2008 at 03:15:12AM -0400, Jeff Mahoney wrote:
>> In the end, though, Andrew's right. We can't go breaking udev prior to
>> 127 with this.
> 
> But it's OK to break various distribution's kernel packaging tools?

No. I still think the right answer is to keep them in a versioned
directory and I'm keeping this patch applied to the SUSE kernel trees.
Udev in the next release understands where to look. It's just clear that
there's some disagreement if that's the right answer for everyone. My
opinion is that if the firmware blobs are built with and shipped with
the kernel, then they're already associated with a particular kernel
version as a dependency the same way we'd treat module dependencies.

It's silly to willfully complicate the situation beyond just including
the firmware blobs with the kernel. Even though it sounds a lot simpler
to just say, "keep a separate firmware package," the reality is that it
creates more work for everyone, developers, users, and packagers alike.
I recently updated the kernel on my notebook to a 2.6.27-rc, only to
find out that the firmware blob that I already had installed was out of
date and the driver was useless without it. This is an example of an
externally-maintained firmware blob, but creating a separate package out
of firmware blobs essentially makes all of them externally maintained
and forces in-kernel developers to jump through the same hoops that
third-party driver maintainers must.

Packagers will need to keep track of every firmware version associated
with every kernel, since users may want to install multiple kernel
versions. This is the entire point of the thread, and it assumes that
the user installing the kernel is even using a packaged kernel. If
they've just built their own and have done a make modules_install ; make
install, then they're out of luck.

Driver maintainers need to worry about remembering to up the version
every time the firmware blob changes. If the blobs are always kept with
the associated kernel version, then it's fire and forget, the same way
internal API changes are.

Putting them in their own directory just makes it obvious and easy for
everyone. The issue is that firmware.sh isn't looking there right now.
Perhaps making optional symlinks is the answer.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkjJLP4ACgkQLPWxlyuTD7I5aQCbBRYn5wv3GbLw1cxUsDr/PxuC
ml0An2WjJwkYEz4hQadUi0PosZe6n6ng
=rY53
-----END PGP SIGNATURE-----
