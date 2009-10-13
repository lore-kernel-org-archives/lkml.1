Return-Path: <linux-kernel-owner+w=401wt.eu-S1759113AbZJMJLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113AbZJMJLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 05:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbZJMJLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 05:11:08 -0400
Received: from mail-vw0-f203.google.com ([209.85.212.203]:62006 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbZJMJLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 05:11:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rJo7LePeCp2nV0T7hKIjmhsSIFvv9g6bkDd7jdduN3RMTcSnjLEeRVXQExvu9SMwuL
         4f97eyHog+2O0e291WpWWrRFCalaA886MUMntxvZn84zxJLhUOtUtQFiOcwn3mqPy2tW
         t8U6FKZajXyeWpnO2lBGu4otxLvAH15kdMU+U=
Date: Tue, 13 Oct 2009 18:10:17 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Lothar Wassmann <LW@KARO-electronics.de>, linux-usb@vger.kernel.org,
       Roland Dreier <rolandd@cisco.com>,
       Yevgeny Petrilin <yevgenyp@mellanox.co.il>, netdev@vger.kernel.org,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org, linux-altix@sgi.com
Subject: Re: [PATCH 2/8] bitmap: Introduce bitmap_set, bitmap_clear,
	bitmap_find_next_zero_area
Message-ID: <20091013091017.GA18431@localhost.localdomain>
References: <1255076961-21325-1-git-send-email-akinobu.mita@gmail.com> <1255076961-21325-2-git-send-email-akinobu.mita@gmail.com> <20091009164100.85a36188.akpm@linux-foundation.org> <20091013021818.GA3898@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013021818.GA3898@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My user space testing exposed off-by-one error find_next_zero_area
in iommu-helper. Some zero area cannot be found by this bug.

Subject: [PATCH] Fix off-by-one error in find_next_zero_area

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 lib/iommu-helper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
index 75dbda0..afc58bc 100644
--- a/lib/iommu-helper.c
+++ b/lib/iommu-helper.c
@@ -19,7 +19,7 @@ again:
 	index = (index + align_mask) & ~align_mask;
 
 	end = index + nr;
-	if (end >= size)
+	if (end > size)
 		return -1;
 	for (i = index; i < end; i++) {
 		if (test_bit(i, map)) {
-- 
1.5.4.3

