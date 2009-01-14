Return-Path: <linux-kernel-owner+w=401wt.eu-S1760847AbZANAUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760847AbZANAUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbZANAUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:20:11 -0500
Received: from matrixpower.ru ([195.178.208.66]:47532 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777AbZANAUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:20:09 -0500
Date: Wed, 14 Jan 2009 03:20:08 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dst@ioremap.net
Subject: Re: [0/7] Distributed storage for drivers/staging merge request
Message-ID: <20090114002008.GD512@ioremap.net>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net> <20090113233932.GA18000@kroah.com> <20090113234734.GA32190@ioremap.net> <20090114000130.GA20811@kroah.com> <20090113161221.b23510b4.akpm@linux-foundation.org> <20090114001546.GC512@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114001546.GC512@ioremap.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 03:15:46AM +0300, Evgeniy Polyakov (zbr@ioremap.net) wrote:
> > Whereas the "do we need this" case for new filesystems isn't this simple.
> 
> More on this, it is a block device which does not work with hardware.
> And yes, question is serious. And you may not believe, but it is not me
> to answer this. I'm happy to provide any needed information.
> In a nutshell, it is a network block device on really huge steroids.

And according to POHMELFS which is a parallel very high-performance
(forget nfs) network filesystem with coherent local cache of data
and metadata.

The only change expected to be done is one additional network command
to parse the data currently sent via netlink. We want to connect to the
new servers by another server request and not by admin steps.

Patch will be somewhat 10-50 lines. And while you at it, please shed a
light on this exports for POHMELFS:

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -513,6 +513,7 @@ int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(add_to_page_cache_lru);
 
 #ifdef CONFIG_NUMA
 struct page *__page_cache_alloc(gfp_t gfp)
@@ -627,6 +628,7 @@ int __lock_page_killable(struct page *page)
 	return __wait_on_bit_lock(page_waitqueue(page), &wait,
 					sync_page_killable, TASK_KILLABLE);
 }
+EXPORT_SYMBOL_GPL(__lock_page_killable);
 
 /**
  * __lock_page_nosync - get a lock on the page, without calling sync_page()



-- 
	Evgeniy Polyakov
