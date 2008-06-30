Return-Path: <linux-kernel-owner+w=401wt.eu-S1762077AbYF3Tua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762077AbYF3Tua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYF3TuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:50:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbYF3TuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:50:17 -0400
Date: Mon, 30 Jun 2008 15:49:12 -0400
From: Rik van Riel <riel@redhat.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splitlru: BDI_CAP_SWAP_BACKED
Message-ID: <20080630154912.15f03b97@bree.surriel.com>
In-Reply-To: <Pine.LNX.4.64.0806302020260.27080@blonde.site>
References: <Pine.LNX.4.64.0806290117510.21758@blonde.site>
	<Pine.LNX.4.64.0806290122330.21758@blonde.site>
	<20080629173841.37CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080630115354.3a75edd3.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0806302020260.27080@blonde.site>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008 20:23:54 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> On Mon, 30 Jun 2008, KAMEZAWA Hiroyuki wrote:
> > 
> > Hmm, how about adding LRU only for shmem/tmpfs ? nonsense ? ;)
> 
> I'd much prefer not: the more LRUs, the more balancing problems;
> And I don't think shmem/tmpfs _deserves_ its own LRUs.
> But it cannot be ruled out.

Tmpfs is often in the same boat as anonymous memory.
Used for shared memory segments, or for files that
are temporary and will be gone soon.

If swap space runs out, tmpfs pages should not be
scanned.

To me, this suggests they should probably continue
to live on the *_ANON LRUs.  Worst case we make
tmpfs pages in files that are not mmaped (/tmp use)
start out on the inactive list, so they get evicted
first.

-- 
All rights reversed.
