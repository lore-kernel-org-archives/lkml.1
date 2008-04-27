Return-Path: <linux-kernel-owner+w=401wt.eu-S1763818AbYD0XKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763818AbYD0XKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbYD0XK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:10:29 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:4818 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbYD0XK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:10:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XIKrwZLgXS9zwkDn4UX3ueRimMUbE7PjnoUbxPo9klIEEQj86ZJ9E1oQyhzTJF1gKIN2kihpGTlDBu/gzMlW8/IHZaiF5LXk4XLCrlce9gT/C7yyxaFm7coiBjioz6Nu88fiPDeKg62CHRKTK4Yx3GUQtNKle0OOze9Ob3eK0Ns=
Message-ID: <9a8748490804271610j65382492v5e2aba99e3c47702@mail.gmail.com>
Date: Mon, 28 Apr 2008 01:10:25 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Patrick J. Volkerding" <volkerdi@slackware.com>
Subject: Re: ld: <...> internal error, aborting at arange-set.c line 202 in arange_set_new
Cc: "Nick Clifton" <nickc@specifixinc.com>,
       "Richard Henderson" <rth@redhat.com>, "Ian Taylor" <ian@airs.com>,
       "Jeff Law" <law@redhat.com>, "Jim Wilson" <wilson@redhat.com>,
       "DJ Delorie" <dj@delorie.com>, "Alan Modra" <amodra@bigpond.net.au>,
       "Michael Meissner" <meissner@redhat.com>,
       "Daniel Jacobowitz" <dan@debian.org>, linux-kernel@vger.kernel.org
In-Reply-To: <9a8748490804271556n3f004a5ds7d4951f3fbc0fdf6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LNX.1.00.0804272326320.14738@dragon.funnycrock.com>
	 <48150178.4050900@slackware.com>
	 <9a8748490804271556n3f004a5ds7d4951f3fbc0fdf6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/28 Jesper Juhl <jesper.juhl@gmail.com>:
> 2008/4/28 Patrick J. Volkerding <volkerdi@slackware.com>:
>
>
> > Jesper Juhl wrote:
>  >
>  > > Hi,
>  > >
>  > > For your information;
>  > > I just test build Linus' tip of the kernel tree (HEAD at
>  > 064922a805ec7aadfafdd27aa6b4908d737c3c1d) on a up-to-date Slackware-current
>  > distro and hit this problem:
>  > >
>  > > ...
>  > >  GEN     .version
>  > >  CHK     include/linux/compile.h
>  > >  UPD     include/linux/compile.h
>  > >  CC      init/version.o
>  > >  LD      init/built-in.o
>  > >  LD      .tmp_vmlinux1
>  > > ld: size of bfd_vma > size of splay_tree types
>  > > ld: BFD (Linux/GNU Binutils) 2.18.50.0.4.20080208 internal error, aborting
>  > at arange-set.c line 202 in arange_set_new
>  > >
>  > > ld: Please report this bug.
>  > >
>  >
>  >  Hello all,
>  >
>  >  Slackware-current does not use binutils 2.18.50.0.4.20080208, but rather
>  > binutils-2.17.50.0.17.  We've run into a few unusual issues with newer
>  > binutils versions, so we tend to be rather cautious about having that
>  > package on the bleeding edge.
>  >
>  >  I'd be curious if using the binutils-2.17.50.0.17 package from
>  > slackware-current would avoid this problem, but also wanted to let people
>  > know that the system in question had a critical part of the toolchain
>  > replaced with something that didn't come from our set of packages.
>  >
>
>  Fron the slackware-current changelog :
>  Sat Feb 23 01:30:50 CST 2008
>  ...
>  d/binutils-2.18.50.0.4-i486-1.tgz: Upgraded to binutils-2.18.50.0.4.
>
>  $ which ld
>  /usr/bin/ld
>  juhl@dragon:~/kernel/linux-2.6$ grep usr/bin/ld /var/log/packages/*
>  ...
>  /var/log/packages/binutils-2.18.50.0.4-i486-1:usr/bin/ld
>  ...
>
>  That's the package I have and it was indeed part of Slackware current
>  when I fetched it.
>
>  I see now, on closer inspection that the changelog also says ;
>
>  Fri Feb 29 14:00:57 CST 2008
>  ...
>  d/binutils-2.17.50.0.17-i486-1.tgz: Reverted to binutils-2.17.50.0.17 due to
>        many reports of ld bugs...
>  ...
>
>  My scripts missed that, but I'll grab that package now and downgrade
>  and try to reproduce the problem.
>
Having downgraded binutils to 2.17.50.0.17.20070615 I no longer see this error.

I now see a different build error with my config, but that's now a new
issue and nothing to do with binutils or Slackware.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
