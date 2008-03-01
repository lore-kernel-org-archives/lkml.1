Return-Path: <linux-kernel-owner+w=401wt.eu-S1759544AbYCATsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544AbYCATsx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 14:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbYCATsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 14:48:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138AbYCATsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 14:48:45 -0500
Message-ID: <47C9AF8F.2050502@redhat.com>
Date: Sat, 01 Mar 2008 20:33:35 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: Ritesh Raj Sarraf <rrs@researchut.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, dm-crypt@saout.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Alasdair G Kergon <agk@redhat.com>,
       Christophe Saout <christophe@saout.de>
Subject: Re: [dm-devel] Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in	dm-crypt
References: <200802281924.03996.rrs@researchut.com>	<20080228232048.51e28c1d.akpm@linux-foundation.org>	<20080229184649.GJ1788@agk.fab.redhat.com>	<200803010029.18320.rrs@researchut.com> <47C9AEF3.7040507@redhat.com>
In-Reply-To: <47C9AEF3.7040507@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(the same patch for 2.6.24)

Milan
--
Add cond_resched() to prevent stuck in big bio processing.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-crypt.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.24.3/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.24.3.orig/drivers/md/dm-crypt.c	2008-02-26 01:20:20.000000000 +0100
+++ linux-2.6.24.3/drivers/md/dm-crypt.c	2008-03-01 16:46:24.000000000 +0100
@@ -374,6 +374,7 @@ static int crypt_convert(struct crypt_co
 			break;
 
 		ctx->sector++;
+		cond_resched();
 	}
 
 	return r;


