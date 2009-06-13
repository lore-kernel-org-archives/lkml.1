Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbZFMG35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbZFMG35 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 02:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZFMG3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 02:29:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54632 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbZFMG3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 02:29:48 -0400
Date: Sat, 13 Jun 2009 08:29:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Michael Chan <mchan@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: -git tree build failure #2: =?utf-8?Q?driv?=
	=?utf-8?Q?ers=2Fnet=2Fcnic=2Ec=3A2520=3A_error=3A_implicit_declaration_of?=
	=?utf-8?B?IGZ1bmN0aW9uIOKAmF9fc3ltYm9sX2dldOKAmQ==?=
Message-ID: <20090613062933.GA14034@elte.hu>
References: <20090612184343.GA11900@elte.hu> <4A32A1E4.8080708@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A32A1E4.8080708@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Ingo Molnar wrote:
> > today's -git fails to build with ipv6 disabled (x86):
> > 
> >   drivers/built-in.o: In function `cnic_get_v6_route':
> >   cnic.c:(.text+0x104c42): undefined reference to `ip6_route_output'
> > 
> > introduced by this new driver:
> > 
> >   a463696: [SCSI] cnic: Add new Broadcom CNIC driver.
> 
> I just posted a patch for this to netdev and it was acked by its maintainer.
> Patch is below.

This solves the first build failure but there's still a second build 
failure:

 drivers/net/cnic.c: In function ‘init_bnx2_cnic’:
 drivers/net/cnic.c:2520: error: implicit declaration of function ‘__symbol_get’
 drivers/net/cnic.c:2520: warning: assignment makes pointer from integer without a cast
 make[1]: *** [drivers/net/cnic.o] Error 1
 make: *** [drivers/net/cnic.o] Error 2

This too triggers with the config i sent. The patch below solves it 
- but i havent done more testing.

	Ingo

Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/cnic.c b/drivers/net/cnic.c
index 8d74037..49135cc 100644
--- a/drivers/net/cnic.c
+++ b/drivers/net/cnic.c
@@ -25,6 +25,8 @@
 #include <linux/delay.h>
 #include <linux/ethtool.h>
 #include <linux/if_vlan.h>
+#include <linux/module.h>
+
 #if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
 #define BCM_VLAN 1
 #endif
