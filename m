Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbXEMGAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbXEMGAk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 02:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755787AbXEMGAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 02:00:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:31906 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbXEMGAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 02:00:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-x-sender:to:cc:subject:message-id:mime-version:content-type;
        b=knFTURPTELTtZfWNhqsmGimXDwIrUYUSIMkzJ5biY851tvVei8SAl2durlrqLJI6BFHLdwRMGpcueaT2oLBQFKIbyeqhZPzkiJx4PjKLqSfr6ReptDr1XN8F9EvFmPfb8jJ0zKuFpE18N9cGQ4CbpiVv6ZeK+0k+n2Tr54Sx/4A=
Date: Sun, 13 May 2007 14:00:32 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
Message-ID: <Pine.LNX.4.64.0705131359200.26974@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

> So give it a good testing. We'll see how the regression tracking ends up
> working, but in order to actually track that, we want people actively
> testing -rc1 and making good reports!

Here's a little patch to fix filemap.c compilation problem ...


Thanks,
Jeff


--- linux/mm/filemap.c.org	2007-05-13 13:54:16 +0800
+++ linux/mm/filemap.c	2007-05-13 13:54:25 +0800
@@ -782,6 +782,7 @@
  	read_unlock_irq(&mapping->tree_lock);
  	return ret;
  }
+EXPORT_SYMBOL(find_get_pages);
  EXPORT_SYMBOL(find_get_pages_tag);

  /**
@@ -840,8 +841,6 @@

  	ra->ra_pages /= 4;
  }
-EXPORT_SYMBOL(find_get_pages);
-EXPORT_SYMBOL(find_get_pages_tag);

  /**
   * do_generic_mapping_read - generic file read routine

