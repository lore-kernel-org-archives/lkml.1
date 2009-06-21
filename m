Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbZFUOJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbZFUOJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 10:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZFUOJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 10:09:29 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:35369 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751914AbZFUOJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 10:09:28 -0400
Date: Sun, 21 Jun 2009 22:09:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Fixes for 2.6.31
Message-ID: <20090621140924.GA3305@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20090613020512.GA21024@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090613020512.GA21024@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes a number of regressions for hardware AES:

* Spurious page faults with AES on Via Nano.
* Fix broken decryption with Intel AES.
* Fix atomic sleep with Intel AES.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Chuck Ebbert (2):
      crypto: padlock-aes - work around Nano CPU errata in ECB mode
      crypto: padlock-aes - work around Nano CPU errata in CBC mode

Huang Ying (3):
      crypto: aes-ni - Fix cbc mode IV saving
      crypto: aes-ni - Do not sleep when using the FPU
      crypto: aes-ni - Remove CRYPTO_TFM_REQ_MAY_SLEEP from fpu template

 arch/x86/crypto/aesni-intel_asm.S  |    5 +-
 arch/x86/crypto/aesni-intel_glue.c |    4 +
 arch/x86/crypto/fpu.c              |    4 +-
 drivers/crypto/padlock-aes.c       |  138 +++++++++++++++++++++++++----------
 4 files changed, 107 insertions(+), 44 deletions(-)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
