Return-Path: <linux-kernel-owner+w=401wt.eu-S965094AbXCGMio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965094AbXCGMio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 07:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965143AbXCGMin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 07:38:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48038 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965094AbXCGMin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 07:38:43 -0500
Date: Wed, 7 Mar 2007 23:38:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 1/4] signalfd v1 - signalfd core ...
Message-Id: <20070307233833.f1482f86.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0703062301590.10398@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com>
	<20070307155553.06c82ca1.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0703062301590.10398@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__7_Mar_2007_23_38_33_+1100_44Kl.jZir./PzOd5"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Mar_2007_23_38_33_+1100_44Kl.jZir./PzOd5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Tue, 6 Mar 2007 23:11:49 -0800 (PST) Davide Libenzi <davidel@xmailserver.org> wrote:
>
> On Wed, 7 Mar 2007, Stephen Rothwell wrote:
>
> > On Tue, 6 Mar 2007 17:36:56 -0800 (PST) Davide Libenzi <davidel@xmailserver.org> wrote:
> > >
> > > The read(2) call will read u32 signal numbers that landed over the
> > > signalfd. It returns the size of the data copied, or zero if the sighand
> > > we are attached to, has been detached.
> >
> > So what about signals that the user asked for a siginfo_t to be returned
> > with?
>
> O-Ren:   "You didn't think it was gonna be that easy, did you?"
> B-Kiddo: "You know, for a second there, yeah, I kinda did."
>
> :)
>
> I could do that, since where I placed the signalfd_notify() I have the
> siginfo. But that is going to make code a little more complex, since the
> simple bitmaks needs to become a queue.

Then, of course, you have to think about how to get the siginfo_t out to
the user process.  Do you just return it from the read after the read
that returns the signal number?  If so, you need to know if the process
did a compat read syscall read or a normal one ...

There may be a better solution.

You probably need the queue anyway because the real time signals are
supposed to queue.

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__7_Mar_2007_23_38_33_+1100_44Kl.jZir./PzOd5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF7rJRFdBgD/zoJvwRAtWZAKCUxccX65u7G3/Li7NkZUxMnECmpgCfUh9b
UBj2W8O3+fIEbQzrsgd3crM=
=ERcI
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Mar_2007_23_38_33_+1100_44Kl.jZir./PzOd5--
