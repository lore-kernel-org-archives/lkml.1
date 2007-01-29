Return-Path: <linux-kernel-owner+w=401wt.eu-S933225AbXA2Gpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225AbXA2Gpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 01:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933241AbXA2Gpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 01:45:38 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41048 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933225AbXA2Gph (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 01:45:37 -0500
Message-Id: <200701290645.l0T6jX0S030597@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
In-Reply-To: Your message of "Sun, 28 Jan 2007 23:08:17 MST."
             <m1d54ymkku.fsf@ebiederm.dsl.xmission.com>
From: Valdis.Kletnieks@vt.edu
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net> <6bffcb0e0701270837i1ec40560l6e61e8876177e9da@mail.gmail.com> <45BBC444.8090109@imap.cc> <20070127134116.06bdadd8.akpm@osdl.org> <200701280241.l0S2f2ga015847@turing-police.cc.vt.edu> <200701290249.l0T2nZt8003676@turing-police.cc.vt.edu>
            <m1d54ymkku.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1170053133_8444P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 29 Jan 2007 01:45:33 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1170053133_8444P
Content-Type: text/plain; charset=us-ascii

On Sun, 28 Jan 2007 23:08:17 MST, Eric W. Biederman said:
> Valdis.Kletnieks@vt.edu writes:

> Does it find sys?  If so perhaps I should do something even more significant.
> I guess if I get many complaints about this I will figure out how to print
> out an appropriate error message.

It found sys, and then the second iteration in in xlate_proc_name it failed
to find net because the de->subdir for sys/net wasn't set.

> > What's the intended semantics of create_proc_entry and xlate_proc_name in
> > this new regime of no subdir pointers? Or am I just (yet again) one of the
> > first to trip over a bug?
> 
> It is supposed to fail in this instance.  If you want something under /proc/sys
> you are supposed to use register_sysctl like everyone else.  If it's not a
> sysctl it should not show up under /proc/sys.

Wasn't my code originally - I think the original author thought that since
all the *other* config stuff for ipv4 was down under /proc/sys/net/ipv4, this
one should be as well because that's where sysadmins would look for it, and
wasn't thinking so much about whether it was a sysctl or not.

> I'm glad to see my cleanup uncovering more bugs, I'm sorry you were the one
> who had to find it.  I will you well fixing your out of tree ipfilter module.

It's easy enough to move the entry under /proc/net or someplace instead.

What's the current advice on what kernel interface to use for this scenario:

In userspace, we do something like this:

(while read foo; do echo $foo > /proc/my_file; done) < /etc/bunch_of_lines

and we want to catch, parse, and save each line as it enters the kernel, and
we end up with several dozen entries saved.

If we do a 'cat /proc/my_file', we iterate across the list of saved lines
and dump them all out.



--==_Exmh_1170053133_8444P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFFvZgNcC3lWbTT17ARAvlnAJ9oSvcBj5QrFE1X0APsK1bfNXMvpwCgtYzY
IcHm4UOUSDBsneXskPo9kwI=
=dd1R
-----END PGP SIGNATURE-----

--==_Exmh_1170053133_8444P--
