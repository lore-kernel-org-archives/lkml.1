Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbYI2Hyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbYI2Hyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 03:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYI2Hyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 03:54:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33675 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbYI2Hyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 03:54:46 -0400
Date: Mon, 29 Sep 2008 09:54:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT PULL] kmemcheck fixlets (for -tip)
Message-ID: <20080929075436.GA11940@elte.hu>
References: <20080928180652.GA8500@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080928180652.GA8500@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Hi Ingo,
> 
> Here is the fixlets branch, including bitfields API. I think it would
> be very nice if you could make this a *separate* branch in -tip, say
> kmemcheck-fixlets or so, as it may touch any part of the kernel and
> doesn't carry the acks of those maintainers.
> 
> With these patches, you should be able to include kmemcheck in 
> auto-testing again. At least it works for me :-)
> 
> You may also kill tip/kmemcheck-dma, which has been integrated already.

branches are hard to kill in Git (anyone pushing back from a tree that 
still has the old branch will re-create it). The name is sufficiently 
generic so we keep keep it. The name can be reused in the future 
eventually.

> The following changes since commit 9f24b3ed3058f022dad24f8304b9ad53adf5aa71:
>   Vegard Nossum (1):
>         x86: use REP MOVS instruction for memcpy if kmemcheck is enabled
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git fixlets-for-tip
> 
> Vegard Nossum (6):
>       kmemcheck: bitfield API
>       net: use kmemcheck bitfields API for skbuff
>       net: annotate bitfields in struct inet_sock
>       ieee1394: annotate bitfield
>       ieee1394/csr1212: fix false positive kmemcheck report
>       kmemcheck: allocate struct siginfo with SLAB_NOTRACK
> 
>  drivers/ieee1394/csr1212.c |    2 ++
>  drivers/ieee1394/nodemgr.c |    7 ++++++-
>  include/linux/kmemcheck.h  |   39 +++++++++++++++++++++++++++++++++++++++
>  include/linux/skbuff.h     |   31 +++++++++++++++++++------------
>  include/net/inet_sock.h    |   24 +++++++++++++++---------
>  kernel/signal.c            |    8 +++++++-
>  net/core/skbuff.c          |    8 ++++++++
>  7 files changed, 96 insertions(+), 23 deletions(-)

pulled into tip/kmemcheck-bitfields, thanks Vegard. I've also propagated 
this new branch into the integration rules of auto-kmemcheck-next.

	Ingo
