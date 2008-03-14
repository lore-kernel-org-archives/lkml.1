Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYCNBXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYCNBXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 21:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYCNBXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 21:23:14 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50880 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbYCNBXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 21:23:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 14 Mar 2008 02:22:30 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: fw-ohci: use dma_alloc_coherent for ar_buffer
To: Jarod Wilson <jwilson@redhat.com>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
In-Reply-To: <47D8679A.10303@s5r6.in-berlin.de>
Message-ID: <tkrat.d74b3aa2387b0f72@s5r6.in-berlin.de>
References: <200803121743.27170.jwilson@redhat.com>
 <47D8679A.10303@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Jarod Wilson wrote:
>> Resolves constant buffer failures on my own x86_64 laptop w/4GB of RAM and
>> likely to fix a number of other failures witnessed on x86_64 systems with
>> 4GB of RAM or more.
>> 
>> Signed-off-by: Jarod Wilson <jwilson@redhat.com>
> 
> Looks good at first glance.  Alas my PCs aren't affected, so I can only 
> test it for lack of regressions.
> 
> I'm tempted to push this to Linus later this week.

I tested it on a 2GB EM64T machine, on PPC32, and i686.  I used the
latter for stress-tests with SBP-2, DV, and IIDC traffic on two buses
with 3 devices each, all active at once.

I had one lock-up during the stress-tests which I suspect is the
handle_at_packet panic, http://bugzilla.kernel.org/show_bug.cgi?id=9617
which is unrelated to this patch.

I committed your patch to linux1394-2.6.git, whose shortlog and diff
from origin..for-linus looks now like this:

Jarod Wilson (2):
      firewire: fw-sbp2: set single-phase retry_limit
      firewire: fw-ohci: use dma_alloc_coherent for ar_buffer

Stefan Richter (9):
      firewire: endianess fix
      firewire: endianess annotations
      firewire: fw-ohci: PPC PMac platform code
      firewire: fw-ohci: Apple UniNorth 1st generation support
      firewire: warn on fatal condition in topology code
      firewire: update Kconfig help text
      firewire: fw-sbp2: fix for SYM13FW500 bridge (Datafab disk)
      ieee1394: sbp2: fix for SYM13FW500 bridge (Datafab disk)
      firewire: fw-ohci: shut up false compiler warning on PPC32

 drivers/firewire/Kconfig          |   50 +++++--------
 drivers/firewire/fw-ohci.c        |  108 +++++++++++++++++++++-------
 drivers/firewire/fw-sbp2.c        |   36 +++++++++-
 drivers/firewire/fw-topology.c    |    3 +-
 drivers/firewire/fw-transaction.c |    2 +-
 drivers/firewire/fw-transaction.h |    6 +-
 drivers/ieee1394/sbp2.c           |    5 ++
 7 files changed, 143 insertions(+), 67 deletions(-)

I'd like to submit this to Linus later today (Friday).  It all looks
like a bit too much for such a late -rc phase; but half of fw-ohci's
diffstat is actually just the added PMac code which has already proven
itself in ohci1394.

There are also some small new commits to linux1394-2.6.git master, whose
history is once again somewhat obfuscated by my pulling 'origin' and
'for-linus' into master, so that vice versa master can be cleanly pulled
into descendants of Linus' tree.

http://me.in-berlin.de/~s5r6/linux1394/updates/2.6.25-rc5/patches/series
gives a better picture of what is currently in the pipeline than git log
would give.
-- 
Stefan Richter
-=====-==--- --== -===-
http://arcgraph.de/sr/

