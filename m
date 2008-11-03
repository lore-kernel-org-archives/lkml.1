Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbYKCM3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbYKCM3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 07:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYKCM3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 07:29:41 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:48847 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbYKCM3l (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 07:29:41 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Pengfei Hu <hpfei.cn@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.27: add a kernel hacking option to protect kernel memory between different modules
In-Reply-To: Your message of "Sun, 02 Nov 2008 22:15:11 +0800."
             <a5f59d880811020615x297ff832kbce705d07318dfa2@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <a5f59d880811020615x297ff832kbce705d07318dfa2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1225715378_3531P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 03 Nov 2008 07:29:39 -0500
Message-ID: <67704.1225715379@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1225715378_3531P
Content-Type: text/plain; charset=us-ascii

On Sun, 02 Nov 2008 22:15:11 +0800, Pengfei Hu said:

> efficiency and simplicity. But now more and more embed application use
> linux. In the traditional embed system, all the task run in kernel and
> share the memory. Using kernel thread can immigrate these application
> easily. So there will be many task run in the kernel.

So the target is embedded systems doing all sorts of stupid-crazy kernel
thread tricks...

> +          Change page table's present flag to prevent other module's accidental
> +          access. This results in a large slowdown and waste more memory, but
> +          helps to find certain types of memory corruptions.

And your solution is to create a large slowdown, which will just make them
look for ways to make it go faster... perhaps including even *more* stupid-crazy
kernel thread tricks?

Can you point at any bugs/failure modes that this patch would detect, but
would *not* be found by any of the already-existing memory debugging tools?

Is it at all sane to expect that a reasonable setting can be done for
things like slab and vmalloc?  What happens when multiple modules allocate
out of the same slab, or even worse, get vmalloc/kmalloc for *different*
things on the same physical page?  It seems that unless you can separate
memory allocations by module, this isn't going to provide a lot of help in
finding memory allocation/usage issues.

And I won't even *start* on all the data structures in the kernel that are
shared across modules - do a 'cat /proc/slabinfo' or equivalent, and ask
yourself how many of those you could tag as "private to module A", or
"read/write by B, read-only by C, no-access by others".

You *really* don't want to re-invent the IBM MVS-style "GETMAIN/FREEMAIN SP=nnn"
mess. Trust me on this one. ;)


--==_Exmh_1225715378_3531P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJDu6ycC3lWbTT17ARApslAJ44w1HEpzjkQ5MPkM5H5+CNxkE9YgCg3lo0
xVNEbai6kkucFhi/P1RMSwg=
=vxsA
-----END PGP SIGNATURE-----

--==_Exmh_1225715378_3531P--
