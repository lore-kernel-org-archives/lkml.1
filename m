Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbZAKLM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbZAKLM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 06:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbZAKLMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 06:12:51 -0500
Received: from smtp.cs.aau.dk ([130.225.194.6]:49793 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbZAKLMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 06:12:50 -0500
X-Greylist: delayed 2121 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Jan 2009 06:12:50 EST
Subject: Re: multiple bugs
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: We La <w.landgraf@yahoo.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <211380.10787.qm@web112201.mail.gq1.yahoo.com>
References: <211380.10787.qm@web112201.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 11 Jan 2009 11:39:20 +0100
Message-Id: <1231670360.15041.41.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lør, 10 01 2009 kl. 20:21 -0800, skrev We La:
> I compile continuously almost all git's and test them on several computers.
> 
> 1) Since the 2.6.27 serie, until 2.6.28 and its gits, on many machines
> the eth connections don't longer work.  The drivers seems to 'work' so
> that with ifconfig the device is listed, however one don't get
> connections nor responses of ping.  Booting instead with 2.6.26.X or
> earlier (changing nothing else on the system), everything works
> correctly.  The routes are unchanged, too.   Probably this is less a
> problem of the eth card drivers but of the routing or package handling.
> 
The 2.6.27 series have been out for a while, so it's not a common bug
you have hit and something must be special in your case. Perhaps its
your config, but it's impossible to pinpoint anything from your
description above.

It sounds like that you could use git-bisect(1) to tell you which commit
it started not working from. According to your description above I'd say
you would want to start with

git bisect start
git bisect good v2.6.26
git bisect bad v2.6.27

and git will respond with something like

Bisecting: 5685 revisions left to test after this
[dd9ca5d9be7eba99d685d733e23d5be7110e9556] USB: usb-serial: fix a sparse
warning about different signedness

Then you'd make, install and test the kernel for this revision and
determine whether it was good or bad and get the next revision by
stating 'git bisect good/bad'. You'd have to repeat this about 13 times.

> 2) For all 2.6.28 -git's , and almost on all machines - office/home
> computers, and laptops inclusive my eeepc and msi win - I get error
> messages like that below.  After the error occures, the video changes
> in a small-letter video mode, and later on trying startx with a
> framebuffer driver, X don't start.   Annexed is also the configuration
> file.

> CONFIG_DRM_I915_KMS=y

Don't set that. The help text for this option warned you:

  Choose this option if you want kernel modesetting enabled by default,
  and you have a new enough userspace to support this. Running old
  userspaces with this enabled will cause pain.  Note that this causes
  the driver to bind to PCI devices, which precludes loading things like
  intelfb.

> 3) For the kernel politics:  For the most new computers / laptops
> which come out and which are runners in the shops -- such like the
> eeepc or ms wind -- often it's only 1-2 drivers which are not yet in
> the kernel -- in this examples, the atl2 or the RL2700E drivers.
> Then it needs almost 1 year until they are included. During this 
> time, people consider Linux as difficult to run on these machines;
> although some distros compile/add drivers, these depends on the
> kernel version.  I suggest to include more fast the few modules for
> the important new computers. Even if these drivers aren't perfect,
> this is better than that people have to compile and install them
> separately. 

Yeah, see [1].

[1] http://lwn.net/Articles/298570/

P.S. Please set a subject for your emails, and make it something more
descriptive than the one I provided if possible.


Simon Holm Thøgersen

