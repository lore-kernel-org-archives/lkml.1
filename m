Return-Path: <linux-kernel-owner+w=401wt.eu-S1751836AbZIHTlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbZIHTlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZIHTlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:41:46 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43174 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZIHTlp (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:41:45 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Beth Kon <eak@us.ibm.com>
Cc: rostedt@goodmis.org, avi@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Wierdness - linux-next KVM patch breaks Dell Latitude D820, KVM not in kernel
In-Reply-To: Your message of "Tue, 08 Sep 2009 09:32:46 EDT."
             <4AA65CFE.50402@us.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <3850.1252332427@turing-police.cc.vt.edu>
            <4AA65CFE.50402@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1252438888_3318P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 08 Sep 2009 15:41:28 -0400
Message-ID: <22130.1252438888@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1252438888_3318P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <22124.1252438888.1@turing-police.cc.vt.edu>

On Tue, 08 Sep 2009 09:32:46 EDT, Beth Kon said:

> > 3) no KVM in this kernel:
> > % grep KVM .config
> > CONFIG_HAVE_KVM=y
> > ## CONFIG_KVM is not set
> >   
> Hi Vladis. I'm at a loss regarding my patch being the problem if it is 
> really the case that CONFIG_KVM is not set.  Are you sure that is the 
> config being used?

Yeah, I was quite confused by the bisect results as well, I may end up
re-doing it just to make sure I didn't screw something up along the way (since
I started it with -rc7/HEAD as the good/bad, but most of the resulting
kernels reported a pre-rc7 release (a 2.6.28 at one point, IIRC, and it
finished at 31-rc2.

%  pwd
/usr/src/valdis/linux-next
% grep KVM .config
CONFIG_HAVE_KVM=y
# CONFIG_KVM is not set

>                    My only other thought (assuming somehow CONFIG_KVM 
> *is* set) is to be sure your repository also has 
> b4eba884776b5ab77fef1febbd3203e54a66d0bd.

Yes, that commit is also in the repository, though I'm not sure what
difference it makes since it hits arch/x86/kvm/x86.c which isn't even built
in my .config.  I'm also confused why the trace.o module *did* get rebuilt
when it doesn't look like it would have needed it, and why that seems to have
been the critical issue.

Oh well.. off to go re-do the bisect, I guess.  Wish me luck. ;)

--==_Exmh_1252438888_3318P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKprNocC3lWbTT17ARAvldAKDMGfnbfKOyXHjKbyChxfutgmvoygCg+X7H
JcfV11OjgVoGtZ5yinogmMw=
=Ugjc
-----END PGP SIGNATURE-----

--==_Exmh_1252438888_3318P--
