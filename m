Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbYAANlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbYAANlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 08:41:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbYAANk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 08:40:57 -0500
Received: from po-out-1718.google.com ([72.14.252.153]:57694 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbYAANk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 08:40:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=R6z7sGGZlcPXGTsWFBLB2RV6WIGu1+rpAd+Lm2VGpV/XLhIFpW9ZtLDYiE/KiFpm+YAwDIGx3okONCeSUTXEYy7I8/epeiPzFz4wgA3uOF0NE92EQqsKenmSVKu6Qknpbe0eZEKItP8x9IMa57XgGqDjN7wDQiQwSVSgDcA6Q1c=
Date: Tue, 1 Jan 2008 21:41:08 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Roland Dreier <rolandd@cisco.com>,
       mshefty@ichips.intel.com, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       hal.rosenstock@gmail.com
Subject: (Try #2) [Patch 5/8] INFINIBAND: Remove 'TOPDIR' from Makefiles
Message-ID: <20080101134108.GE2499@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080101071311.GA2496@hacking> <20080101073331.GF2496@hacking> <20080101102637.GE28913@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101102637.GE28913@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> -EXTRA_CFLAGS += -I$(TOPDIR)/drivers/net/cxgb3 \
>> -		-I$(TOPDIR)/drivers/infiniband/hw/cxgb3/core
>
>> +EXTRA_CFLAGS += -I$(objtree)/drivers/net/cxgb3 \
>Drop $(TOPDIR) like this:
>> +EXTRA_CFLAGS += -Idrivers/net/cxgb3 \
>
>> +		-I$(objtree)/drivers/infiniband/hw/cxgb3/core
>And this line can be deleted - there is no such directory.
>At least not in my tree.

Yes, correct. Thank you.

----------->

This patch removes TOPDIR from infiniband Makefiles.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <mshefty@ichips.intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/drivers/infiniband/hw/cxgb3/Makefile b/drivers/infiniband/hw/cxgb3/Makefile
index 36b9898..7e7b5a6 100644
--- a/drivers/infiniband/hw/cxgb3/Makefile
+++ b/drivers/infiniband/hw/cxgb3/Makefile
@@ -1,5 +1,4 @@
-EXTRA_CFLAGS += -I$(TOPDIR)/drivers/net/cxgb3 \
-		-I$(TOPDIR)/drivers/infiniband/hw/cxgb3/core
+EXTRA_CFLAGS += -Idrivers/net/cxgb3
 
 obj-$(CONFIG_INFINIBAND_CXGB3) += iw_cxgb3.o
 
