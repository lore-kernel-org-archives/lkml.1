Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbYFAPgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbYFAPgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 11:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYFAPgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 11:36:39 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:35676 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbYFAPgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 11:36:38 -0400
Date: Sun, 1 Jun 2008 21:05:12 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm 06/12] split LRU lists into anon & file sets
Message-ID: <20080601153512.GA8159@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Rik van Riel <riel@redhat.com>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lee Schermerhorn <lee.schermerhorn@hp.com>,
	Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
References: <20080529202246.322317334@redhat.com> <20080529202312.447477416@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080529202312.447477416@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rik van Riel <riel@redhat.com> [2008-05-29 16:22:52]:

> From: Rik van Riel <riel@redhat.com>
> 
> Split the LRU lists in two, one set for pages that are backed by
> real file systems ("file") and one for pages that are backed by
> memory and swap ("anon").  The latter includes tmpfs.
> 
> Eventually mlocked pages will be taken off the LRUs alltogether.
> A patch for that already exists and just needs to be integrated
> into this series.
> 
> This patch mostly has the infrastructure and a basic policy to
> balance how much we scan the anon lists and how much we scan
> the file lists. The big policy changes are in separate patches.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
>

Hi, Rik,

My problems with OOM continue, despite the changes incorporated into
memcontrol.c. While I am investigating the problem, the code below
seemed incorrect.

 
> +static inline void
> +del_page_from_active_file_list(struct zone *zone, struct page *page)
> +{
> +	del_page_from_lru_list(zone, page, LRU_INACTIVE_FILE);
>  }

Shouldn't this be del_page_from_lru_list(zone, page, LRU_ACTIVE_FILE)?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
