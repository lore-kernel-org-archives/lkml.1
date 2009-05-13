Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbZEMIiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbZEMIiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 04:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbZEMIiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 04:38:12 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:3905 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbZEMIiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 04:38:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=O33G6OlHR+6cV5gnIpXpqzOLLrm5ZtYfqJ6kTlBzogB/v2MZxsz0B//EhPDbAHwXNG
         ajTM3wcQPzGpSMjYPAnJXFnyQwGidP7oHqxLkg1sei/4PvXXLNiH33m/BoOIsaZgSWnU
         XVknnfZCX6CMtMhIMCDjRCl9iAFtQoAZd7NEE=
Date: Wed, 13 May 2009 17:37:58 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: kernel BUG at mm/slqb.c:1411!
Message-Id: <20090513173758.2f3d2a50.minchan.kim@barrios-desktop>
In-Reply-To: <20090513163826.7232.A69D9226@jp.fujitsu.com>
References: <20090513163826.7232.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 16:42:37 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

Hmm. I don't know slqb well.
So, It's just my guess. 

We surely increase l->nr_partial in  __slab_alloc_page.
In between l->nr_partial++ and call __cache_list_get_page, Who is decrease l->nr_partial again.
After all, __cache_list_get_page return NULL and hit the VM_BUG_ON.

Comment said :

        /* Protects nr_partial, nr_slabs, and partial */
  spinlock_t    page_lock;

As comment is right, We have to hold the l->page_lock ?



-- 
Kinds Regards
Minchan Kim
