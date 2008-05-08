Return-Path: <linux-kernel-owner+w=401wt.eu-S933500AbYEHRt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933500AbYEHRt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764997AbYEHRn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:43:58 -0400
Received: from ns2.suse.de ([195.135.220.15]:33563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764985AbYEHRn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:43:57 -0400
Date: Thu, 8 May 2008 10:42:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Julia Lawall <julia@diku.dk>, Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 14/16] CRYPTO: cryptd: Correct kzalloc error test
Message-ID: <20080508174228.GO855@suse.de>
References: <20080508173436.454278564@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="crypto-cryptd-correct-kzalloc-error-test.patch"
In-Reply-To: <20080508174122.GA855@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Julia Lawall <julia@diku.dk>

[CRYPTO] cryptd: Correct kzalloc error test

[ Upstream commit: b1145ce395f7785487c128fe8faf8624e6586d84 ]

Normally, kzalloc returns NULL or a valid pointer value, not a value to be
tested using IS_ERR.

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 crypto/cryptd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -190,8 +190,10 @@ static struct crypto_instance *cryptd_al
 	int err;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
-	if (IS_ERR(inst))
+	if (!inst) {
+		inst = ERR_PTR(-ENOMEM);
 		goto out;
+	}
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,

-- 
