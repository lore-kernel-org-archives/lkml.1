Return-Path: <linux-kernel-owner+w=401wt.eu-S971374AbXILSDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971374AbXILSDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 14:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969545AbXILSDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 14:03:17 -0400
Received: from ns.firmix.at ([62.141.48.66]:60709 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969294AbXILSDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 14:03:14 -0400
Subject: Re: Building a kernel-source RPM (not a kernel RPM)?
From: Bernd Petrovitsch <bernd@firmix.at>
To: Dan Stromberg <dstromberglists@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <pan.2007.09.12.17.30.59.597440@gmail.com>
References: <pan.2007.09.12.16.13.41.195991@gmail.com>
	 <1189616966.31502.75.camel@tara.firmix.at>
	 <pan.2007.09.12.17.30.59.597440@gmail.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 12 Sep 2007 20:03:06 +0200
Message-Id: <1189620186.31502.96.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.315 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.315 required=5
X-Spam-Score: -2.315 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-12 at 10:31 -0700, Dan Stromberg wrote:
> On Wed, 12 Sep 2007 19:09:26 +0200, Bernd Petrovitsch wrote:
[...]
> >> I'm on a SuSE system.
> >> 
> >> I'm working on automating the install of said system, but it needs a
> >> Linus kernel - 2.6.21.7 specifically, and it needs kernel source too so
> >> that we can build modules in the field as needed.
> > 
> > Find a kernel-source.*.src.rpm or kernel-*.src.rpm or whatever SuSE uses
> > for
> > nameing convention and reverse engineer the .spec file.
> > Fedora BTW abandoned kernel-source* and they have now a website with a
> > description
> > how to produce a configured kernel source tree (e.g. for out-of-tree
> > modules).
> 
> So this is as smooth as producing kernel-source RPM's gets?

I had no problems with the kernel-source.*.rpm approach.

> I might be better off sticking with a .tar.bz2 and repointing symlinks.
> 
> >> I see you can make an rpm of a bootable kernel with "make rpm".
> > 
> > Well, then there must be a .spec file somewhere which just wants to be
> > extended.
> 
> I'm not sure this is going to be any easier to automate, if that's what's
> required.

The problem, that automation of such a task depend on various factors
(which
may be somewhat private):
- you have a linux-$VERSION:tar.bz2
- optionally, you have patches. And some distributions have *lots* of.
- you need a .config (and run `make oldconfig`).
You have to decide on each (independent if you build an RPM or a script)
of
them.
If you need regularly .rpm from ongoing development, you probably need
to figure out first which procedure is the best.
It's from a conceptual view different if you either have your kernel
source
and produce new kernels every other day for testing, etc. (then simple
scripts
are more than enough) or you produce a .rpm every other day to install
it and
keep it for months (for whatever reason).

[...]
> I may just stick them in a bash script and forget about the RPM.  Or are

A .spec file is a just set of "scripts", some meta-information and
produces
a container. And you have a package management at install time.
I can't decide if the more effort for the .rpm pays off for you - that
also
depends on factors like "geek value", "number of installations", ....
And that the reason for me to suggest to find a recent SuSEs
kernel.src.rpm
and start from there or find the one behind the "make rpm" thingy.

[....]
> On OpenSuSE 10.2, there appears to be:
> 
> # find / /home -xdev -ls | egrep -- '-> /usr/src/linux'
> 215641    0 lrwxrwxrwx   1 root     root           26 Sep 11 17:50 /lib/modules/2.6.18.2-34-default/source -> /usr/src/linux-2.6.18.2-34
> 213786    0 lrwxrwxrwx   1 root     root           45 Sep 11 17:50 /lib/modules/2.6.18.2-34-default/build -> /usr/src/linux-2.6.18.2-34-obj/x86_64/default

Yup, but these (usually) don't change at run-time. So I would put them
into
the .rpm like any other sym-link (or delete and create them in the
pre-rm and
post-install scripts if it's not fixed at rpm-build-time).

> > just put the correct ones in /lib/modules/$(uname -r)/ and the full name
> > in
> > /boot/grub/menu.lst.
> 
> Which correct "ones"?  Sometimes pronouns aren't shortcuts :)

Sorry, the correct sym-links. Since I have no experience with recent
SuSE,
I didn't know that's the same as in the RedHat world (but they point
somewhere else).

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


