Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbYIIPkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbYIIPkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbYIIPkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:40:23 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54707 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753370AbYIIPkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:40:22 -0400
X-Sasl-enc: mEVASSH+ZFfktXkKDmv1/fD2a+ukEYeNhsiQfHvPj+HZ 1220974820
Message-ID: <48C698DF.7010401@fastmail.fm>
Date: Tue, 09 Sep 2008 17:40:15 +0200
From: Michael J Gruber <michaeljgruber+gmane@fastmail.fm>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Junio C Hamano <gitster@pobox.com>
CC: Bert Wesarg <bert.wesarg@googlemail.com>,
       "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>,
       Git Mailing List <git@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       guilt@lists.josefsipek.net, Brandon Philips <brandon@ifup.org>
Subject: Re: [ANNOUNCE] Guilt v0.31
References: <20080908135244.GB27550@josefsipek.net> <36ca99e90809081133s58e3d32h8b85804f5bb76902@mail.gmail.com> <20080908184322.GE27550@josefsipek.net> <36ca99e90809081150v4ad6e7a0n72b5cca39e02b1bc@mail.gmail.com> <7vmyiifnwa.fsf@gitster.siamese.dyndns.org> <48C64B8B.5000606@fastmail.fm> <48C673CF.2000107@fastmail.fm> <7vd4jd8i9b.fsf@gitster.siamese.dyndns.org>
In-Reply-To: <7vd4jd8i9b.fsf@gitster.siamese.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano venit, vidit, dixit 09.09.2008 17:13:
> Michael J Gruber <michaeljgruber+gmane@fastmail.fm> writes:
> 
>> I would go about renaming quick-install-doc to quick-install-man, introducing quick-install-html doing the analogous using the "html" branch and quick-install-doc doing both, which would be more in line with the install-doc target.
>>
>> Are there any objections to renaming quick-install-doc to quick-install-man?
> 
> What does it improve?

It makes it more systematic.

Right now:

Documentation/Makefile:
all: builds html and man
install: installs only man (depends on man)
install-{info,html}: installs $foo (depends on $foo)
quick-install: installs man from man branch

Makefile:
doc: builds html and man (-C D all)
install-doc: installs only man (-C D install)
install-{info,html}: installs $foo (-C D install-$foo)
quick-install-doc: installs man from man branch (-C D install-$foo)

So there is a distinct asymmetry between build targets and install
targets. Wouldn't you expect "make install" to install what "make"
builds? That is true, but "make install-doc" doesn't install what "make
doc" builds.

Put it differently:
doc = man + html for build targets
doc = man for install targets

What's worse: "make doc" fails if you don't have xmlto, even though
"make install-doc" may succeed; but you'll never try it when the build
fails. Until a few hours ago I thought I couldn't build man pages at
work (asciidoc, but no xmlto), and I had never heard about
quick-install-doc until I looked at the Makefiles in detail.

> IOW, can't you do what you want to do (I am assuming that what you want to
> do is to be able to copy out the pregenerated contents from convenience
> branches) without such a rename?

Sure I can. "Namen sind Schall und Rauch". Names don't matter.
quick-install-html would follow the above logic. I just think that the
doc logic is flawed.

So, my suggestion is that doc = man + html, whether it appears in a
build target or an install target.

> If you rename the target, I am reasonably sure you would break somebody's
> build procedure.  It is a separate topic if there are large number of such
> somebody, or just a limited few.

I keep hearing this argument, and I'm even more surprised to hear it
right after a major release. If not now then when's a good time for
cleaning up confusing inconsistencies?

Michael
