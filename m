Return-Path: <linux-kernel-owner+w=401wt.eu-S1761353AbXEPExq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761353AbXEPExq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 00:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbXEPExk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 00:53:40 -0400
Received: from mail.tnnet.fi ([217.112.240.26]:52044 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbXEPExj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 00:53:39 -0400
Message-ID: <464A8E4B.74E1DB2E@users.sourceforge.net>
Date: Wed, 16 May 2007 07:53:31 +0300
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: markus reichelt <ml@mareichelt.de>
Cc: linux-crypto@nl.linux.org, linux-kernel@vger.kernel.org
Subject: Re: Announce loop-AES-v3.2a file/swap crypto package
References: <4649F5DC.87043316@users.sourceforge.net> <20070515211642.GA1058@tatooine.rebelbase.local>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

markus reichelt wrote:
> * Jari Ruusu <jariruusu@users.sourceforge.net> wrote:
> > loop-AES changes since previous release:
> > - loop_twofish.c loop_serpent.c loop_blowfish.c modules included.
> >   They are not built by default. Add EXTRA_CIPHERS=y make parameter
> >   to build them.
> 
> Just curious, will the ciphers package also be continued/available
> separately as before or is it merged from now on into the loop-aes
> package?

Since loop-AES package now provides equivalent funtionality, it doesn't make
sense to maintain second package providing redundant functionality. The
merge was done because of difficulties getting versioned symbols to match
between two separately compiled packages. Even if separate package were to
be maintained (it won't be), it would not work well with versioned symbols.
If you want to blame someone for that, then blame mainline linux kbuild
guys.

I forgot to clearly say following in loop-AES-v3.2a README:

This command builds loop module with AES cipher integrated, as usual:

    make KEYSCRUB=y LINUX_SOURCE=/some/path/here

This command builds loop module with AES cipher integrated, and separate
twofish, serpent, and blowfish loop cipher modules:

    make KEYSCRUB=y EXTRA_CIPHERS=y LINUX_SOURCE=/some/path/here

This command builds only twofish, serpent, and blowfish loop cipher modules.
This assumes that kernel patch version of loop-AES is being used and is
enabled in kernel configuration:

    make EXTRA_CIPHERS=y BUILD_LOOP=n LINUX_SOURCE=/some/path/here

Key scrubbing, as enabled by KEYSCRUB=y make command line parameter,
currently only works for AES cipher. It has no effect on twofish, serpent,
and blowfish ciphers.

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
