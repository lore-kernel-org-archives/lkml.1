Return-Path: <linux-kernel-owner+w=401wt.eu-S1763137AbXKTScM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763137AbXKTScM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760240AbXKTS0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:26:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51906 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761630AbXKTS0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:26:54 -0500
Date: Tue, 20 Nov 2007 10:24:28 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sebastian Siewior <sebastian@breakpoint.cc>,
       Jordan Crouse <jordan.crouse@amd.com>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 16/29] geode: Fix not inplace encryption
Message-ID: <20071120182428.GR28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="geode-fix-not-inplace-encryption.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Sebastian Siewior <sebastian@breakpoint.cc>

patch 2e21630ddc3fb717dc645356b75771c6a52dc627 in mainline.

Currently the Geode AES module fails to encrypt or decrypt if
the coherent bits are not set what is currently the case if the
encryption does not occur inplace. However, the encryption works
on my Geode machine _only_ if the coherent bits are always set.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
Acked-by: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/crypto/geode-aes.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -110,8 +110,7 @@ geode_aes_crypt(struct geode_aes_op *op)
 	 * we don't need to worry
 	 */
 
-	if (op->src == op->dst)
-		flags |= (AES_CTRL_DCA | AES_CTRL_SCA);
+	flags |= (AES_CTRL_DCA | AES_CTRL_SCA);
 
 	if (op->dir == AES_DIR_ENCRYPT)
 		flags |= AES_CTRL_ENCRYPT;

-- 
