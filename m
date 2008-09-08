Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbYIHTSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbYIHTSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 15:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYIHTSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 15:18:00 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:48769 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbYIHTSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 15:18:00 -0400
From: Junio C Hamano <gitster@pobox.com>
To: "Bert Wesarg" <bert.wesarg@googlemail.com>
Cc: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>,
       "Git Mailing List" <git@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       guilt@lists.josefsipek.net, "Brandon Philips" <brandon@ifup.org>
Subject: Re: [ANNOUNCE] Guilt v0.31
References: <20080908135244.GB27550@josefsipek.net>
 <36ca99e90809081133s58e3d32h8b85804f5bb76902@mail.gmail.com>
 <20080908184322.GE27550@josefsipek.net>
 <36ca99e90809081150v4ad6e7a0n72b5cca39e02b1bc@mail.gmail.com>
Date: Mon, 08 Sep 2008 12:17:25 -0700
In-Reply-To: <36ca99e90809081150v4ad6e7a0n72b5cca39e02b1bc@mail.gmail.com>
 (Bert Wesarg's message of "Mon, 8 Sep 2008 20:50:03 +0200")
Message-ID: <7vmyiifnwa.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: D9180734-7DDA-11DD-825F-3113EBD4C077-77302942!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Bert Wesarg" <bert.wesarg@googlemail.com> writes:

> I must admit, that I don't like these extra tarballs with docs. I
> always expect, that the manpages are nicely installed if I type 'make
> install' (or at least with a install-doc target). But I need to
> download this extra package, and extract it to the right place, there
> is no Makefile whatsoever. In case of git its really annoying, because
> the help mechanism is relying on the manpages (i.e. git help <cmd> or
> git <cmd> --help, but you know this).

There is no need to feel "it[']s really annoying", as install-doc from the
tarball distribution works out of the box.

I used 1.6.0.1 in the demonstration below, but this is nothing new in that
version but has been like this for quite some time (it is how sample RPMs
binary packages are built, so the procedure ought to work):

    $ ls -1 /usr/bin/git ;# to show there is no other "git" on this box
    ls: /usr/bin/git: No such file or directory
    $ mkdir /var/tmp/16
    $ cd /var/tmp/16
    $ wget http://www.kernel.org/pub/software/scm/git/git-1.6.0.1.tar.gz
    $ tar xf git-1.6.0.1.tar.gz
    $ cd git-1.6.0.1
    $ make prefix=/var/tmp/16test install install-doc
    $ PATH=/var/tmp/16test/bin:/usr/bin:/bin
    $ export PATH
    $ unset MANPATH
    $ git help cat-file | cat -s | tail -n 8
    Reformatting git-cat-file(1), please wait...
    DOCUMENTATION
           Documentation by David Greaves, Junio C Hamano and the git-list
           <git@vger.kernel.org>.

    GIT
           Part of the git(1) suite

    Git 1.6.0.1                       09/08/2008                   GIT-CAT-FILE(1)


The extra tarballs for documentation are also given as courtesy because
they are supposed to be platform independent and some people do not want
to generate them themselves (even though they could).

Either be thankful for the availability of tarballs, or ignore them and
generate them yourself --- it's your choice.
