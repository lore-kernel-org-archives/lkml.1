Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbYBXNNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbYBXNNt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 08:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbYBXNNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 08:13:39 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:44525 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755310AbYBXNNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 08:13:38 -0500
Date: Sun, 24 Feb 2008 08:10:02 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: John Levon <levon@movementarian.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-ID: <20080224131001.GA7150@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	John Levon <levon@movementarian.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, sandmann@redhat.com, tglx@tglx.de,
	hpa@zytor.com
References: <20080219123756.6261c13c@laptopd505.fenrus.org> <20080223001130.d8922136.akpm@linux-foundation.org> <20080223113724.GB31304@elte.hu> <20080223135335.GA28464@totally.trollied.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223135335.GA28464@totally.trollied.org.uk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 01:53:35PM +0000, John Levon wrote:
> On Sat, Feb 23, 2008 at 12:37:24PM +0100, Ingo Molnar wrote:
> 
> > It's 200 lines of pretty well isolated code for something that is 
> > already much more usable to me than 10 years of oprofile. Really, i'd 
> > much rather take 200 lines of poor kernel code written by a userspace 
> > developer for stuff that _already works better_, than to have ~2000 
> > lines of oprofile code and an unusable (to me) user-space tool written 
> > by kernel developers.

I think it's fair to say that oth oprofile and sysprof can use some
improvements.  There are a couple of questions that immediately come
to mind, including the most obvious one, *if* as you John clams, the
oprofile kernel had all of the functionality for the GUI, why wasn't
it used --- could it *perhaps* because the kernel interface for
oprofile wasn't documented well?  Heck, even if sysprof is 200 lines
of code versus 2000 lines of kernel code, most people don't write
extra code unless it's because the 2000 lines of pre-existing code
isn't well documented enough.

> Firstly, the distributions should have set this up automatically. That
> they don't is a distributor bug. The sheer madness of Linux not leaving
> a vmlinux file in a stable known location is hardly something oprofile
> can be blamed for.

Wrong Answer.  People who write userspace helpers *have* to do the
work of the distro's.  It's a bad, bad, bad, Bad, BAD idea to leave it
up to the distributions.  It means that some distributions won't get
it right; other distributions will do it in different ways, making it
harder for users to switch between distro's and making it harder for
people to write distribution-neutral HOWTO's.

There are plenty of things that can be done, including using search
paths to try to find vmlinuz; or maybe even proposing a new standard
such as say for example /lib/modules/`uname -r`/vmlinux being a
synlink to the location of vmlinux.  We already have
/lib/modules/`uname -r`/build and /lib/modules/`uname -r`/source, for
example.

The abdication of responsibility and the lack of trying to solve the
usability issues is one of the things that really worries me about
*all* of Linux's RAS tools.  We can and should do better!  And it's
really embarassing that the RAS maintainers seem (I assume you are one
of the oprofile maintainers), seem to be blaming this on the victims,
the people who are complaining about using *your* tool.  Yes, it's a
shame that Ingo didn't try to fix your tool; open source, and scratch
your own itch and all of that.  To be sure.  But at the *same* *time*
don't you have enough pride to take a look at a tools which so
obviously has massive lacks in the usability department, and tried to
fix it years ago?  There's more than enough blame to go around twenty
times over, I would think.

						- Ted
