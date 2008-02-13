Return-Path: <linux-kernel-owner+w=401wt.eu-S932650AbYBMQnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650AbYBMQnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbYBMQnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:43:07 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:55547 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbYBMQnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:43:06 -0500
Message-ID: <47B31DE7.9060400@kernel.org>
Date: Wed, 13 Feb 2008 08:42:15 -0800
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Ben Nizette <bn@niasdigital.com>, netfilter-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: BUG: 2.6.25-rc1: iptables postrouting setup causes oops
References: <1202816761.3299.19.camel@moss.renham>	<20080213004829.fd8afdc7.akpm@linux-foundation.org>	<20080213101024.39347322@dhcp-252-066.norway.atmel.com> <20080213012231.46865608.akpm@linux-foundation.org>
In-Reply-To: <20080213012231.46865608.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Haavard,

It means your application is not capable(sic) of using the upper 32-bits
of the 64-bit capability sets supported by this newer kernel.

You might consider rebuilding the offending application linking it
against a newer version of libcap:

http://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/

However, it is a warning and, for any existing app that doesn't care
about newly added capabilities, the warning is benign.

Cheers

Andrew

Andrew Morton wrote:
| On Wed, 13 Feb 2008 10:10:24 +0100 Haavard Skinnemoen
<hskinnemoen@atmel.com> wrote:
|
|> On Wed, 13 Feb 2008 00:48:29 -0800
|> Andrew Morton <akpm@linux-foundation.org> wrote:
|>
|>> On Tue, 12 Feb 2008 22:46:01 +1100 Ben Nizette <bn@niasdigital.com>
wrote:
|>>
|>>> On an AVR32, root over NFS, config attached, running (from a startup
|>>> script):
|>>>
|>>> iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
|>>>
|>>> Results in (dmesg extract including a bit of context for good measure):
|>>> -------------8<----------------
|>>> VFS: Mounted root (nfs filesystem).
|>>> Freeing init memory: 72K (90000000 - 90012000)
|>>> eth0: no IPv6 routers present
|>>> warning: `dnsmasq' uses 32-bit capabilities (legacy support in use)
|> Hmm. What does that mean? What size do capabilities normally have?
|
| My near-namesake put than in, but I immediately forgot what it means?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFHsx3n+bHCR3gb8jsRAjlNAKDK4RLJsPsMPN96JJnTj3U25Bx91ACdESeN
2P3V2ISny33KY6v107iHsKU=
=1jND
-----END PGP SIGNATURE-----
