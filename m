Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbYHMMQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbYHMMQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 08:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbYHMMQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 08:16:28 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:54720 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751634AbYHMMQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 08:16:27 -0400
Date: Wed, 13 Aug 2008 22:16:20 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Subject: Re: Crypto Fixes for 2.6.27
Message-ID: <20080813121620.GA23142@gondor.apana.org.au>
References: <20080501102812.GA7151@gondor.apana.org.au> <20080727063659.GA936@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080727063659.GA936@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push contains a bunch of fixes for new code/regressions
introduced since 2.6.26 plus a fix for an old padlock bug that
has risen to the surface due to recent FPU changes.

Previously the bug was mostly harmless though it had the potential
to leak FPU state, but since 2.6.26 it has become lethal resulting
in crashes if the padlock is used during process creation.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (3):
      crypto: tcrypt - Fix AEAD chunk testing
      crypto: hash - Fix digest size check for digest type
      crypto: hash - Add missing top-level functions

Lee Nipper (1):
      crypto: talitos - Add handling for SEC 3.x treatment of link table

Suresh Siddha (1):
      crypto: padlock - fix VIA PadLock instruction usage with irq_ts_save/restore()

 crypto/digest.c                  |    2 -
 crypto/tcrypt.c                  |   28 +++++++++++++-------
 drivers/char/hw_random/via-rng.c |    8 +++++
 drivers/crypto/padlock-aes.c     |   28 +++++++++++++++++++-
 drivers/crypto/padlock-sha.c     |    9 ++++++
 drivers/crypto/talitos.c         |   54 ++++++++++++++++++++++++++++-----------
 include/asm-x86/i387.h           |   32 +++++++++++++++++++++++
 include/crypto/hash.h            |   18 +++++++++++++
 8 files changed, 153 insertions(+), 26 deletions(-)
 
Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
