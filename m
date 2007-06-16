Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbXFPANM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbXFPANM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 20:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbXFPAM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 20:12:58 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:23926 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756144AbXFPAM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 20:12:58 -0400
Date: Sat, 16 Jun 2007 02:12:55 +0200
From: Carlo Wood <carlo@alinoe.com>
To: linux-kernel@vger.kernel.org
Subject: My kernel hangs again: Help with git please
Message-ID: <20070616001255.GA11403@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Somewhere between 2.6.18 and 2.6.19, a patch was added to the
kernel that makes it hang on my machine after the message:

apgart: Detected an Intel 965G Chipset.

When I upgraded to 2.6.22-rc4 (from debian trunk), I still ran
into this same bug.

After installing git for the first time, I made my first
little steps with git - but it didn't get any further then
an attempt to mount my root because I had done my configuration
wrong (due the fact that libata seems to have moved).

Later, I managed to get the configuration right, compiled
HEAD (I think) and got a working 2.6.22-rc4 (+ patches).
I was very happy, and assumed that by coincidence the very
bug that was introduced shortly after 2.6.18 that made my
machine hang during boot, was fixed only two or so days
after I joined linux-kernel and installed git, somewhere
after 2.6.22-rc4 ... What a coincidence right?

Indeed, I thought it was a bit TOO much of a coincidence.
So I just HAD to see that patch that fixed the problem,
and I tried to used git bisect to find the patch that changes
the behaviour from a hang to a working kernel (that I am
now using to write this very mail).

Surprise: Nothing I try produces a working kernel anymore?!

Therefore I have the following questions:

1) What git command will ASSURE that I get the LATEST
   kernel tree checked out?
 
I tried this:

hikaru:/usr/src/kernel/git/linux-2.6>git branch -l
* bisect
  master
  origin
hikaru:/usr/src/kernel/git/linux-2.6>git reset --hard HEAD
hikaru:/usr/src/kernel/git/linux-2.6>git rev-list --max-count=1 bisect
c420bc9f09a0926b708c3edb27eacba434a4f4ba

And, assuming I have c420bc9f09a0926b708c3edb27eacba434a4f4ba at that
moment, then git reset --hard HEAD didn't do what I wanted: that is
namely -rc3 even! I can see THAT in the Makefile -- but whenever I
see -rc4 in the Makefile, that doesn't garantee in any way (apparently)
that I have the latest of the latest.

2) Is there some way to find back the exact version (git id)
from the .config, System.map and vmlinuz image (or /proc, since I can
boot it)? Because that is all I have left from the time that I managed
to create a working kernel :(

-- 
Carlo Wood <carlo@alinoe.com>
