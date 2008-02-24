Return-Path: <linux-kernel-owner+w=401wt.eu-S1759397AbYBXSWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397AbYBXSWX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 13:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbYBXSWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 13:22:15 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59656 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752844AbYBXSWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 13:22:14 -0500
Date: Sun, 24 Feb 2008 13:19:14 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: John Levon <levon@movementarian.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-ID: <20080224181914.GE7150@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	John Levon <levon@movementarian.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, sandmann@redhat.com, tglx@tglx.de,
	hpa@zytor.com
References: <20080219123756.6261c13c@laptopd505.fenrus.org> <20080223001130.d8922136.akpm@linux-foundation.org> <20080223113724.GB31304@elte.hu> <20080223135335.GA28464@totally.trollied.org.uk> <20080224131001.GA7150@mit.edu> <20080224163240.GA30518@totally.trollied.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224163240.GA30518@totally.trollied.org.uk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 04:32:40PM +0000, John Levon wrote:
> > There are plenty of things that can be done, including using search
> > paths to try to find vmlinuz; or maybe even proposing a new standard
> > such as say for example /lib/modules/`uname -r`/vmlinux being a
> 
> At the time when I was trying to fix this, I wasn't aware of any way to
> propose a new standard and get distributions to follow it - is there
> some way now? Informally I discussed this problem several times with
> many people without any resolution. As regards searching informal paths,
> this is extremely risky - get the wrong vmlinux and we end up with
> inaccurate results, which is worse than no results.

The way that /lib/modules/`uname -r`/build was standardize was via
mail to LKML, years ago.  It was declared so, "make install" for base
kernel Makefiles did that, and the distro's picked it up pretty
quickly thereafter.

In terms of picking the right vmlinux, how about a kernel patch which
stashes the MD5 checksum of vmlinux in a convenient location the
compressed kernel which can be pulled out via querying
/sys/kernel/vmlinux_cksum?  If the problem is making sure you have the
right vmlinux, there are some fairly simple ways of assuring this ---
it's just a matter of thinking creatively.

> > The abdication of responsibility and the lack of trying to solve the
> > usability issues is one of the things that really worries me about
> > *all* of Linux's RAS tools.  We can and should do better!  And it's
> > really embarassing that the RAS maintainers seem (I assume you are one
> > of the oprofile maintainers), seem to be blaming this on the victims,
> > the people who are complaining about using *your* tool.  Yes, it's a

Let me make it clear that the problems go far beyond oprofile.  I have
similar issues of disquietude about the easy of use of SystemTap,
kdump, and all of the other RAS system tools.  It may be the problem
is that the companies who fund the development of the RAS tools are
stopping before they can be made turn-key and easy to use by kernel
developers, as opposed to assuming that the distro's will do all of
the hard work productizing them and actually making them *usuable*.

The problem is that not enough mainline kernel developers use these
tools, mostly because they aren't easy enough for them to use.  I
remember complaining about kdump, and I got the same answer, "Oh, it's
the distro's job to make it easy to use."  Which is fine, except that
means very few people actually use it (how many kernel developers use
RHEL and SLES as their day-to-day development OS, as opposed to Fedora
or Debian, et. al.?), and since there aren't lots of kernel developers
using it, once the people who are funded to support the RAS tools get
reassigned to other projects, what's left is in a terrible shape to be
used by mainline kernel developers, and then the tools effectively
become unused and then unmaintained.....

						- Ted
