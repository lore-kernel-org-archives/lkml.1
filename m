Return-Path: <linux-kernel-owner+w=401wt.eu-S933604AbXF2Pqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604AbXF2Pqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 11:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760758AbXF2PqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 11:46:24 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48824 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757475AbXF2PqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 11:46:23 -0400
Date: Fri, 29 Jun 2007 16:49:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: mista.tapas@gmx.net, bunk@stusta.de, nix@esperi.org.uk, galibert@pobox.com,
       tiwai@suse.de, kloczek@rudy.mif.pg.gda.pl, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070629164945.26891025@the-village.bc.nu>
In-Reply-To: <E1I4HtE-0003A5-00@dorka.pomaz.szeredi.hu>
References: <20070624200837.16e11305@the-village.bc.nu>
	<87tzssextf.fsf@hades.wkstn.nix>
	<20070628210614.GC6087@stusta.de>
	<200706291352.42833.mista.tapas@gmx.net>
	<E1I4HtE-0003A5-00@dorka.pomaz.szeredi.hu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007 16:56:05 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:
> Not as if it would be hard to add ioctl support to fuse.  What fuse
> can't handle is the data argument of ioctl(), so the most it could do
> is give the filesystem a pid (tid) and a virtual address.  The
> userspace fs could then get/put the data through /proc/<pid>/mem.

Hork...

Identify the generic ioctls that are relevant to a FUSE file system and
have real meaning *and* are useful. Teach fuse to turn those to and from
messages properly and if you must add any others (ie if there is good
reason to want them then add a single FUSEFS ioctl something like

	struct fusefs_ioctl {
		u32 opcode;
		void *data_in;
		void *data_out;
		u16 size_in;
		u16 size_out;
	}

so that anything totally weird can be passed through without
horrible /proc/... hacks and without putting tons of cases into FUSE

		
