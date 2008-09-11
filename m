Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbYIKIOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbYIKIOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 04:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbYIKIOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 04:14:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:39496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbYIKIN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 04:13:59 -0400
Message-ID: <48C8D33F.2050804@suse.com>
Date: Thu, 11 Sep 2008 04:13:51 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
References: <1221087719.13621.50.camel@macbook.infradead.org>	 <20080910.160505.14060698.davem@davemloft.net>	 <1221088512.13621.58.camel@macbook.infradead.org>	 <20080910.162423.40167601.davem@davemloft.net> <1221119068.6309.8.camel@californication>
In-Reply-To: <1221119068.6309.8.camel@californication>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Marcel Holtmann wrote:
> Hi Dave,
> 
>>> It's definitely not something we should be doing upstream though.
>> So you think it's ok that every Debian user has to learn this
>> magic incantation just to use current kernels?
>>
>> I don't think it's nice to break things like this on people,
>> especially such a large group.  Getting this stuff to work is hard
>> enough, and we're just putting yet another barrier into the situation
>> and that can only mean less testers and contributors.
>>
>> I do know several people who aren't testing and contributing because
>> the whole firmware shakeup is so bolixed and they really are exasperated
>> after spending hours trying to get it to work.
> 
> it is that the Debian maintainer screwed this up. Upstream never
> promoted kernel versioned directories for the firmware. I had a long
> discussion with Dave about it at OLS and using the kernel version is
> just plain wrong. The driver maintainers should version the firmware if
> they break it in an API incompatible way.

They "should," but is that happening now? Out of all the firmware blobs
installed with 2.6.27-rcX, only the edgeport drier actually versions
them - and they're versioned because the driver requires different
versions for different hardware.

> To shed some light into the problem with Debian/Ubuntu. They install the
> firmware in /lib/firmware/`uname -r`/ and everytime they bump their ABI
> number, they have to install all the firmware again. This is just
> braindead. Their udev script actually checks /lib/firmware first and
> then the kernel versioned directory. So that is just fine.

Well, what we're doing is including the firmware blobs inside the kernel
packages. So, yeah, we install all the firmware blobs again, but they're
installed with the modules that we're installing all over again anyway.
All the firmware blobs currently included in 2.6.27-rcs total about
540k, so the wasted disk space is largely negligible when compared to
the size of installing an additional kernel and module set.

We check /lib/firmware/$(uname -r) /lib/firmware
/usr/local/lib/firmware, in that order.

> Problem comes when installing let say 2.6.27 since then the firmware
> will be looked up in /lib/firmware/ and /lib/firmware/2.6.27/ and
> actually it will not be found. Since it is in /lib/firmware/2.6.26-xx/
> or something similar.

In what case? After you install a new kernel and then reboot? You have
the same problem with the modules that need the firmware blobs.

> So having the kernel install everything in /lib/firmware works just fine
> with every distro. However looking for firmware that is not shipped with
> the kernel, we have a problem since Debian/Ubuntu just not installs it
> in the right directory. And there is nothing the kernel can do about it
> since it will not touch firmware it doesn't ship. The distro has to fix
> their firmware or the users have to place a copy in /lib/firmware/ where
> it actually should have been in the first place.

It works just fine until the user wants to install an additional, newer,
kernel and the blob has changed but the filename hasn't.

- -Jeff


- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkjI0z8ACgkQLPWxlyuTD7LPkQCeOGxTOsUivMmjabTrkHd7ssJ3
OBIAnidEMgduuQ4WCXN8JSEhJ4Gij7Iv
=3Lng
-----END PGP SIGNATURE-----
