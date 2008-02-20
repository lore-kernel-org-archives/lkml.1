Return-Path: <linux-kernel-owner+w=401wt.eu-S1764619AbYBTAxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764619AbYBTAxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbYBTAxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:53:10 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:3612 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbYBTAxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:53:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=eXovrTTh8nroAUxRPAoRNtbsfTOAm7Jdic+X92j6oS1iSc2SbR4YvdD9xWZlEv0dcKHFFoMqsfJGcZm8ocjSSaTdy8FB/FURU7lGxZrnMHYd7NPg9DjMA79NJ82nuUTKmN5dPlXvq3kgheMdzXs5oZ9OM8aJpuhKT3E8l4W0Ph4=
Message-ID: <b6a2187b0802191653q4dfaa32cl96b9278e97606ef0@mail.gmail.com>
Date: Wed, 20 Feb 2008 08:53:06 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Dave Airlie" <airlied@linux.ie>
Subject: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Greg KH" <gregkh@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 16, 2008 5:00 AM, Greg KH <gregkh@suse.de> wrote:

> > Also, I've tried CONFIG_DETECT_SOFTLOCKUP=n, but this doesn't fix it either.
>
> Ok, this looks to be something else.
>
> > Here's the last dmesg after suspend-to-disk and hang there...
> >
> > CPU 1 is now offline
> > SMP alternatives: switching to UP code
> > PM: Syncing filesystems ... done.
> > Freezing user space processes ... (elapsed 0.00 seconds) done.
> > Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> > PM: Shrinking memory...  ^H-^Hdone (0 pages freed)
> > PM: Freed 0 kbytes in 0.10 seconds (0.00 MB/s)
> > ACPI: Preparing to enter system sleep state S4
> > Suspending console(s)
> >
> > [ ... it just hangs here ... press power-switch does the job, and
> > system is able to resume upon powering on ]
>
> Wait, this is a suspend-to-disk issue.  Totally different than the "will
> not power off" issue.
>
> Can you start a new thread on this, and add the suspend people to it?


I bisected down this one commit that causes the problem with
suspend-to-disk on Lenovo X60s (i945 chipset).

commit ba8bbcf6ff4650712f64c0ef61139c73898e2165
Author: Jesse Barnes <jesse.barnes@intel.com>
Date:   Thu Nov 22 14:14:14 2007 +1000

    i915: add suspend/resume support

    Add suspend/resume support to the i915 driver.  Moves some of the
    initialization into the driver load routine, and fixes up places where we
    assumed no dev_private existed in some of the cleanup paths.  This allows
    us to suspend/resume properly even if X isn't running.

    Signed-off-by: Dave Airlie <airlied@linux.ie>


There where problem reverting the some i915 files with the latest
linux git pull, so I copied those i915*.{h,c} prior to this commit,
and problem went away.


Suspend-to-ram, suspend-to-disk all working now.


Thanks,
Jeff.
