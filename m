Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbYI1SHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbYI1SHO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 14:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYI1SHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 14:07:00 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:14803 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbYI1SHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 14:07:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=Q+3jRfZAOAT5A9X4DPRuRoav+e8oTpG2A/ykY9SnjbaUJTyk/Iv1wydSlpzDG7R17b
         V2HGi/qbANVUImH8Xv9R4LMpoUvLcPATZ/S9kqpcHtAoMNnPxA/IavYUvar2soHVfvOI
         Us4pIdi0LKPh8wjaVOc3ctlJC3J3vv//KrVgI=
Date: Sun, 28 Sep 2008 20:06:52 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] kmemcheck fixlets (for -tip)
Message-ID: <20080928180652.GA8500@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here is the fixlets branch, including bitfields API. I think it would
be very nice if you could make this a *separate* branch in -tip, say
kmemcheck-fixlets or so, as it may touch any part of the kernel and
doesn't carry the acks of those maintainers.

With these patches, you should be able to include kmemcheck in auto-testing
again. At least it works for me :-)

You may also kill tip/kmemcheck-dma, which has been integrated already.


The following changes since commit 9f24b3ed3058f022dad24f8304b9ad53adf5aa71:
  Vegard Nossum (1):
        x86: use REP MOVS instruction for memcpy if kmemcheck is enabled

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git fixlets-for-tip

Vegard Nossum (6):
      kmemcheck: bitfield API
      net: use kmemcheck bitfields API for skbuff
      net: annotate bitfields in struct inet_sock
      ieee1394: annotate bitfield
      ieee1394/csr1212: fix false positive kmemcheck report
      kmemcheck: allocate struct siginfo with SLAB_NOTRACK

 drivers/ieee1394/csr1212.c |    2 ++
 drivers/ieee1394/nodemgr.c |    7 ++++++-
 include/linux/kmemcheck.h  |   39 +++++++++++++++++++++++++++++++++++++++
 include/linux/skbuff.h     |   31 +++++++++++++++++++------------
 include/net/inet_sock.h    |   24 +++++++++++++++---------
 kernel/signal.c            |    8 +++++++-
 net/core/skbuff.c          |    8 ++++++++
 7 files changed, 96 insertions(+), 23 deletions(-)

Thanks,


Vegard
