Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbYFJSic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbYFJSic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 14:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbYFJSiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 14:38:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752984AbYFJSiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 14:38:19 -0400
Date: Tue, 10 Jun 2008 11:37:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-mm@kvack.org, Rik van Riel <riel@redhat.com>
Subject: Re: 2.6.26-rc5-mm2  compile error in vmscan.c
Message-Id: <20080610113733.8d924c0e.akpm@linux-foundation.org>
In-Reply-To: <484E6A68.4060203@aitel.hist.no>
References: <20080609223145.5c9a2878.akpm@linux-foundation.org>
	<484E6A68.4060203@aitel.hist.no>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 13:50:00 +0200 Helge Hafting <helge.hafting@aitel.hist.no> wrote:

> Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc5/2.6.26-rc5-mm2/
> > 
> > - This is a bugfixed version of 2.6.26-rc5-mm1 - mainly to repair a
> >   vmscan.c bug which would have prevented testing of the other vmscan.c
> >   bugs^Wchanges.
> > 
> 
> Interesting to try out, but I got this:
> 
>   $ make
>    CHK     include/linux/version.h
>    CHK     include/linux/utsrelease.h
>    CALL    scripts/checksyscalls.sh
>    CHK     include/linux/compile.h
>    CC      mm/vmscan.o
> mm/vmscan.c: In function 'show_page_path':
> mm/vmscan.c:2419: error: 'struct mm_struct' has no member named 'owner'
> make[1]: *** [mm/vmscan.o] Error 1
> make: *** [mm] Error 2
> 
> 
> I then tried to configure with "Track page owner", but that did not 
> change anything.
> 

Thanks.  I guess this will get you going.

--- a/mm/vmscan.c~mm-only-vmscan-noreclaim-lru-scan-sysctl-fix
+++ a/mm/vmscan.c
@@ -2400,6 +2400,7 @@ static void show_page_path(struct page *
 		       dentry_path(dentry, buf, 256), pgoff);
 		spin_unlock(&mapping->i_mmap_lock);
 	} else {
+#ifdef CONFG_MM_OWNER
 		struct anon_vma *anon_vma;
 		struct vm_area_struct *vma;
 
@@ -2413,6 +2414,7 @@ static void show_page_path(struct page *
 			break;
 		}
 		page_unlock_anon_vma(anon_vma);
+#endif
 	}
 }
 
_


