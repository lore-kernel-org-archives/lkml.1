Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbYIKHPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbYIKHPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 03:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYIKHPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 03:15:21 -0400
Received: from ns.suse.de ([195.135.220.2]:55213 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbYIKHPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 03:15:20 -0400
Message-ID: <48C8C580.5020803@suse.com>
Date: Thu, 11 Sep 2008 03:15:12 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Faidon Liambotis <paravoid@debian.org>
Cc: David Miller <davem@davemloft.net>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
References: <48C68507.6000609@suse.com>	<1221087719.13621.50.camel@macbook.infradead.org> <20080910.160505.14060698.davem@davemloft.net> <48C8BC17.5050508@debian.org>
In-Reply-To: <48C8BC17.5050508@debian.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Faidon Liambotis wrote:
> David Miller wrote:
>>> Firmware really _isn't_ version-specific.
>> Tell that to every Debian and Debian derived system on the planet.
>>
>> To my knowledge, it is only fedora and possibly one or two other dists
>> that put the firmware files in a unary /lib/firmware location, rather
>> than a versioned /lib/firmware/$KERNELRELASE one.
> [not speaking on behalf of the project, the kernel team or the
> respective maintainers]
> 
> Apparently and afaik you are misinformed:

Well that's the thing. These are specific firmware packages that exist
outside of those created by the kernel. My original patch wasn't
proposing using /lib/firmware/$KERNELRELEASE for *all* firmware blobs,
just those that are generated and installed by the kernel build process.

The problem occurs when you have multiple versions of the kernel
installed and they all want to put firmware blobs into /lib/firmware.
The firmware blobs created by the kernel aren't versioned liked those in
the examples you've provided, so you end up with a bunch of blobs with
potentially different contents, all with the same names.

I'm not suggesting killing /lib/firmware-located blobs at all. That's
where you look once you discover that /lib/firmware/$KERNELRELEASE
doesn't have the blob you're looking for. That's where firmware packages
like the examples below would still place their files. I see no reason
to change that. If the blobs are versioned so that a particular name
always contains the same contents, that's fine too. What we can't have
is files in the same location with different contents.

In the end, though, Andrew's right. We can't go breaking udev prior to
127 with this.

- -Jeff

> $ dpkg -L firmware-bnx2 (or [1])
> ...
> /lib/firmware/bnx2-06-4.0.5.fw
> /lib/firmware/bnx2-09-4.0.5.fw
> ...
> 
> $ dpkg -L firmware-iwlwifi (or [2])
> ...
> /lib/firmware/iwlwifi-3945-1.ucode
> /lib/firmware/iwlwifi-4965-1.ucode
> /lib/firmware/iwlwifi-4965-2.ucode
> ...
> 
> $ dpkg -L firmware-qlogic (or [3])
> ...
> /lib/firmware/ql2100_fw.bin
> /lib/firmware/ql2200_fw.bin
> /lib/firmware/ql2300_fw.bin
> /lib/firmware/ql2322_fw.bin
> /lib/firmware/ql2400_fw.bin
> /lib/firmware/ql2500_fw.bin
> ...
> 
> etc. for the other firmware packages[4].
> 
> Regards,
> Faidon
> 
> 1: http://packages.debian.org/sid/all/firmware-bnx2/filelist
> 2: http://packages.debian.org/sid/all/firmware-iwlwifi/filelist
> 3: http://packages.debian.org/sid/all/firmware-qlogic/filelist
> 4: http://packages.debian.org/firmware


- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkjIxYAACgkQLPWxlyuTD7LuSgCgmAOte+y8dU1TWODKPNwRnrCK
KO8An1VnOh+KvsfHrgtXZ1H/xSdCYuVL
=3/a7
-----END PGP SIGNATURE-----
