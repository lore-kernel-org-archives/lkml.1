Return-Path: <linux-kernel-owner+w=401wt.eu-S1759402AbYCATqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbYCATqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 14:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbYCATqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 14:46:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084AbYCATqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 14:46:11 -0500
Message-ID: <47C9AEF3.7040507@redhat.com>
Date: Sat, 01 Mar 2008 20:30:59 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ritesh Raj Sarraf <rrs@researchut.com>
CC: Alasdair G Kergon <agk@redhat.com>,
       device-mapper development <dm-devel@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Christophe Saout <christophe@saout.de>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dm-crypt@saout.de
Subject: Re: [dm-devel] Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
References: <200802281924.03996.rrs@researchut.com> <20080228232048.51e28c1d.akpm@linux-foundation.org> <20080229184649.GJ1788@agk.fab.redhat.com> <200803010029.18320.rrs@researchut.com>
In-Reply-To: <200803010029.18320.rrs@researchut.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ritesh Raj Sarraf wrote:

> 1) Initialize a device using dm-crypt and LUKS
> 2) Create a filesystem on top of it and mount it.
> 3) Write huge amount of data (as a normal user). Something like 150GB.
>
> As the load goes hight (to something like 12-14), the kernel lock-up is logged 
> into dmesg.
> At that moment, the OS is barely responsive.
>
>   
Please could you try to reproduce it with this patch applied?
(patch for 2.6.25-rc3, for 2.6.24 will follow - code changed here)

Milan
mbroz@redhat.com
--

Add cond_resched() to prevent stuck in big bio processing.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-crypt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b04f98d..2032228 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -432,6 +432,7 @@ static int crypt_convert(struct crypt_config *cc,
 			/* fall through*/
 		case 0:
 			ctx->sector++;
+			cond_resched();
 			continue;
 		}
 


