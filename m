Return-Path: <linux-kernel-owner+w=401wt.eu-S1163277AbXD1Rqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163277AbXD1Rqf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163278AbXD1Rqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:46:35 -0400
Received: from mail.tnnet.fi ([217.112.240.26]:55496 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163277AbXD1Rqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:46:34 -0400
X-Greylist: delayed 1210 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Apr 2007 13:46:33 EDT
Message-ID: <463383B6.C3B5AE2C@users.sourceforge.net>
Date: Sat, 28 Apr 2007 20:26:14 +0300
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: Gisle =?iso-8859-1?Q?S=E6lensminde?= 
	<Gisle.Salensminde@bccs.uib.no>
Cc: linux-crypto@nl.linux.org, linux-kernel@vger.kernel.org
Subject: Re: entropy of /dev/random vs. openssl rand
References: <20070428110652.GI13982@tatooine.rebelbase.local> <463345DA.7010106@cbu.uib.no>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gisle Sælensminde wrote:
> Some people argue that a periodically reseeded cryptographic-quality
> random number generator is as secure as a true random number generator for
> all practical purposes.
[snip]
> I personally can't think of any realistic scenario where /dev/random would
> make you safe while /dev/urandom would make you sorry.

No problem if cryptographic-quality random number generator is reseeded
using high quality entropy. But saving/reseeding PRNG using a plaintext file
as most distros seem to do at shutdown and boot does not count as secure.
/dev/urandom state may be predictable for some time after boot. /dev/random
at least waits for new entropy before handing out random bits, and avoids
that predictable state pitfall.

Do most distros attempt to overwrite /var/lib/urandom/random-seed or
whatever after it has been used to reseed /dev/urandom? Does any distro
attempt to overwrite that file?
  
For the record, loop-AES versions of mount/losetup/swapon that set up random
key loop devices, use /dev/urandom. But they also attempt to work-around
possibly predictable boot-time /dev/urandom bits. The work-around is
basically random-seed save/restore (to backing device) but with 20
overwrites of saved-state after it has been used to create new encryption
keys. See source for more details.

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
