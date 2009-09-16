Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbZIPGqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbZIPGqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 02:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbZIPGqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 02:46:49 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42001 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbZIPGqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 02:46:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Sep 2009 15:44:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: [BUGFIX] fix walk systm ram range for infiniband (Was Re:
 [BUGFIX][mmotm] fix walk system ram range patch (Was Re: mmotm on powerpc:
 walk_memory_resource?
Message-Id: <20090916154439.b08932c8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.1.00.0909152315380.25569@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0909152224400.29857@sister.anvils>
	<20090916092644.fb53279a.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.1.00.0909152315380.25569@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 23:16:47 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 16 Sep 2009, KAMEZAWA Hiroyuki wrote:
> 
> > Index: mmotm-2.6.31-Sep14/arch/powerpc/mm/mem.c
> > ===================================================================
> > --- mmotm-2.6.31-Sep14.orig/arch/powerpc/mm/mem.c
> > +++ mmotm-2.6.31-Sep14/arch/powerpc/mm/mem.c
> > @@ -166,7 +166,7 @@ walk_system_ram_range(unsigned long star
> >  	}
> >  	return ret;
> >  }
> > -EXPORT_SYMBOL_GPL(walk_memory_resource);
> > +EXPORT_SYMBOL_GPL(walk_system_ram_range);
> >  
> >  /*
> >   * Initialize the bootmem system and give it all the memory we
> > 
> 
> Um, doesn't drivers/infiniband/hw/ehca/ehca_mrmw.c need to be fixed too?
> 
Hmm?..yes. nice catch...
my GTAGS doesn't catch it...maybe need to be updated..
I'm sorry that I didn't imagine this is widely used because this was under
CONFIG_MEMORY_HOTPLUG....

How about this ?
==
walk-system-ram-range.patch failes to catch recent change in
inifiniband. This is a fix.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 drivers/infiniband/hw/ehca/ehca_mrmw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: mmotm-2.6.31-Sep14/drivers/infiniband/hw/ehca/ehca_mrmw.c
===================================================================
--- mmotm-2.6.31-Sep14.orig/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ mmotm-2.6.31-Sep14/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -2463,7 +2463,7 @@ int ehca_create_busmap(void)
 	int ret;
 
 	ehca_mr_len = 0;
-	ret = walk_memory_resource(0, 1ULL << MAX_PHYSMEM_BITS, NULL,
+	ret = walk_system_ram_range(0, 1ULL << MAX_PHYSMEM_BITS, NULL,
 				   ehca_create_busmap_callback);
 	return ret;
 }




