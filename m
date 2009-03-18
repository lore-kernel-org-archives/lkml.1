Return-Path: <linux-kernel-owner+w=401wt.eu-S1757853AbZCRSpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbZCRSpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 14:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbZCRSpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 14:45:03 -0400
Received: from kroah.org ([198.145.64.141]:36719 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750737AbZCRSpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 14:45:01 -0400
Date: Wed, 18 Mar 2009 11:32:32 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: The Linux Staging tree, what it is and is not.
Message-ID: <20090318183232.GA11594@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

It's been many months since the Linux Kernel developers conference, where the
linux-staging tree was discussed and role changed.  It turns out that people
are still a bit confused as to what the staging tree is for, and how it works.

So here's a short summary, I'm not going into the history or background here,
that's a much longer writeup that I'd be glad to do if people are interested.


The Linux Staging Tree, what it is and is not.

What the Linux Staging tree is:
  The Linux Staging tree (or just "staging" from now on) is used to hold
  stand-alone[1] drivers and filesystems that are not ready to be merged into
  the main portion of the Linux kernel tree at this point in time for various
  technical reasons.  It is contained within the main Linux kernel tree so
  that users can get access to the drivers much easier than before, and to
  provide a common place for the development to happen, resolving the
  "hundreds of different download sites" problem that most out-of-tree drivers
  have had in the past.

What the Linux Staging tree is not:
  The staging tree is not a place to dump code and run away, hoping that
  someone else will to the cleanup work for you.  While there are developers
  available and willing to do this kind of work, you need to get them to agree
  to "babysit" the code in order for it to be accepted.

Location and Development:
  The staging tree is now contained within the main Linux kernel source tree
  at the location drivers/staging/.  All development happens within the main
  kernel source tree, like any other subsystem within the kernel.  This means:
	- the linux-next tree contains the latest version of the staging tree,
	  with bugfixes that are about to be merged into Linus's tree, as well
	  as the patches that are to be merged into the next major kernel
	  release.
	- if you wish to do work on the staging tree, checkout the linux-next
	  tree and send patches based on that.

Runtime:
  When code from the staging tree is loaded in the kernel, a warning message
  will be printed to the kernel log saying:
    MODULE_NAME: module is from the staging directory, the quality is unknown, you have been warned.
  and the kernel will be tainted with the TAINT_CRAP flag.  This flag shows up
  in any kernel oops that might be produced after the driver has been loaded.

  Note, most kernel developers have expressed the warning that they will not
  work on bugs for when this taint flag has happened, so if you run into a
  kernel problem after loading such a module, please work to reproduce the
  issue without a staging module loaded in order to be able to get help from
  the community.

If anyone has any questions that this summary doesn't answer, please let me
know.

thanks,

greg k-h


[1] stand-alone means no changes needed in other places within the kernel.
There are some exceptions to this:
  - Documenation for the code can live in the Documentation/ directory
    although this isn't recommended.
  - Firmware for the drivers can live in the firmware/ directory, this is
    recommended.
  - Some symbols might need to be exported from the main portion of the kernel
    source tree.  This is acceptable as long as the relevant subsystem
    maintainer agrees with this export.
