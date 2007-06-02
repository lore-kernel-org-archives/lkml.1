Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbXFBN5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbXFBN5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 09:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757338AbXFBN5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 09:57:11 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:51660 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757243AbXFBN5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 09:57:11 -0400
Date: Sat, 2 Jun 2007 15:57:12 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@suse.de>
Subject: 2.6.22-rc3-mm1: Xen compile error with X86_CMPXCHG=n
Message-ID: <20070602135711.GB5500@stusta.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting the following compile error in 2.6.22-rc3-mm1 with 
CONFIG_X86_CMPXCHG=n (with -Werror-implicit-function-declaration - 
otherwise it would be a link error):

<--  snip  -->

...
  CC      drivers/xen/grant-table.o
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc3-mm1/drivers/xen/grant-table.c: In function ‘gnttab_end_foreign_access_ref’:
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc3-mm1/drivers/xen/grant-table.c:203: error: implicit declaration of function ‘sync_cmpxchg’
make[3]: *** [drivers/xen/grant-table.o] Error 1

<--  snip  -->

Adding a dependency of XEN on X86_CMPXCHG should not be a problem and 
not prevent any reasonable real-life usage.

But what worries me is that a seemingly architecture independent 
driver uses a function only available in some configurations.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

