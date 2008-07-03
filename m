Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbYGCUq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbYGCUq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 16:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbYGCUqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 16:46:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43926 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbYGCUqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 16:46:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Handling of suspend/hibernation patches
Date: Thu, 3 Jul 2008 22:47:32 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200807032247.34049.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently, we've had some problems with the handling of suspend/hibernation
patches, because they tend to touch multiple subsystems at a time.  As a
result, it usually is not clear which tree they should be included in and at
the moment there are suspend/hibernation patches in the PCI, ACPI, x86
trees, as well as in -mm.  Of course the resulting dependencies between those
trees are a pain to Stephen and their maintainers.

After the last Kernel Summit we tried to create a branch in the ACPI tree for
suspend/hibernation patches (thanks Len!) and that had worked quite well until
we started to work on the core device power management.  This coincided with
the creation of linux-next and collecting suspend/hibernation patches in the
ACPI tree became inconvenient.

Now, we could go back to the old way of handling suspend/hibernation patches,
which was to merge them through -mm, but the disadvantage of this would be that
the patches wouldn't go through linux-next.  However, I'd like
suspend/hibernation patches to be included in linux-next, so that they can get
as much testing as possible.

For this reason I'd like to create a quilt-based series of suspend/hibernation
(PM sleep) patches, that Stephen will be able to pull from, with the following
rules:
* the patch series will be based on linux-next and will be rebased as often
  as necessary
* the patch series will be periodically (most probably once a week) posted
  to linux-pm and linux-acpi; additionally the maintainers of the subsystems
  affected by the patches will be sent CCs of the messages with them, so that
  they can pick those patches up
* patches taken into the other subsystem trees will be dropped from the
  patchset and the resulting dependencies will be reflected by the annotations
  in the 'series' file
* the patches that are still in the series when the merge window opens, but
  are accepted by the appropriate maintainers, will be put into a git branch
  and pushed to Linus towards the end of the merge window.

If you agree to this plan, I'd like to start by creating the patch series out
of the suspend/hibernation patches that are in -mm at the moment and one
additional patch that was accepted by Len, but not added to the ACPI tree
because of some dependencies with the other subsystem trees.

Thanks,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
