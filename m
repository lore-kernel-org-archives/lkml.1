Return-Path: <linux-kernel-owner+w=401wt.eu-S1763822AbZFMVLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763822AbZFMVLh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 17:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbZFMVL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 17:11:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37588 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbZFMVL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 17:11:29 -0400
Date: Sat, 13 Jun 2009 22:35:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: -git tree build failure =?utf-8?B?IzI6?=
	=?utf-8?Q?_drivers=2Fnet=2Fcnic=2Ec=3A2520=3A_error=3A_implicit_declarati?=
	=?utf-8?B?b24gb2YgZnVuY3Rpb24g4oCYX19zeW1ib2xfZ2V04oCZ?=
Message-ID: <20090613203539.GA9239@elte.hu>
References: <20090612184343.GA11900@elte.hu> <4A32A1E4.8080708@oracle.com> <20090613062933.GA14034@elte.hu> <alpine.LFD.2.01.0906131309560.3237@localhost.localdomain> <20090613203100.GA14294@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090613203100.GA14294@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > Why do we need to do it twice?
> 
> Hm, indeed ... weird - i pasted that error message from a direct 
> reproducer and when i added module.h the build failure 
> disappeared. James - please discard the second patch for now, 
> there's something fishy here.

I still had the window open that had the build failure:

  LD      sound/pci/snd-es1968.o
  CC      fs/btrfs/zlib.o
drivers/net/cnic.c: In function ‘init_bnx2_cnic’:
drivers/net/cnic.c:2524: error: implicit declaration of function 
‘__symbol_get’
drivers/net/cnic.c:2524: warning: assignment makes pointer from 
integer without a cast
distcc[22461] ERROR: compile drivers/net/cnic.c on ph/32 failed
make[2]: *** [drivers/net/cnic.o] Error 1
make[2]: *** Waiting for unfinished jobs....
  CC      drivers/ide/trm290.o
  CC      drivers/scsi/cxgb3i/cxgb3i_ddp.o
  LD      sound/pci/snd-fm801.o
  CC      net/sched/sch_drr.o
  CC      fs/cifs/xattr.o
  CC      drivers/scsi/mpt2sas/mpt2sas_base.o

So it's real - even if the fix is bogus. But it's a different config 
- i'll now try to figure out which one it is and why the build fails 
...

	Ingo
