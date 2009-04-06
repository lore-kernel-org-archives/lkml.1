Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbZDFBJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbZDFBJR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 21:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbZDFBI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 21:08:59 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:58846 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbZDFBI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 21:08:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:mime-version
         :content-type;
        b=Ol+9XvddGh0NCWkOPZvKWa6s0wx6a8l+8UIz+vRmpS6DQo/2GJ6gjwsQgSjvFnq8Cs
         Kvw+RMqWsci0sbIwZgsenxTN/QuYEYK/iwukSyjgqD48T9IXFDJL0prlZVjjnFjTt+9o
         UvfWBUfhJp64mCJxnkDd25YSrIUDehQqeMh1g=
Date: Mon, 6 Apr 2009 09:08:36 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix mm/filemap.c:841: error: redefinition of
 '__kcrctab_add_to_page_cache_lru'
Message-ID: <Pine.LNX.4.64.0904060902010.14894@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Compiling linux from latest git pull resulted in these errors ...

mm/filemap.c:841: error: redefinition of '__kcrctab_add_to_page_cache_lru'
mm/filemap.c:518: error: previous definition of 
'__kcrctab_add_to_page_cache_lru' was here


Here's a patch to fix it. add_to_page_cache_lru was already defined in 
line 518.

Thanks,
Jeff


--- linux/mm/filemap.c.org	2009-04-06 08:25:41 +0800
+++ linux/mm/filemap.c	2009-04-06 08:25:48 +0800
@@ -838,7 +838,6 @@
  	rcu_read_unlock();
  	return ret;
  }
-EXPORT_SYMBOL(add_to_page_cache_lru);

  /**
   * find_get_pages_contig - gang contiguous pagecache lookup
