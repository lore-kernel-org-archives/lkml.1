Return-Path: <linux-kernel-owner+w=401wt.eu-S933106AbXDUJ5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbXDUJ5G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 05:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933114AbXDUJ5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 05:57:06 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933100AbXDUJ4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 05:56:51 -0400
Date: Sat, 21 Apr 2007 02:55:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
Subject: Re: [PATCH 07/10] mm: count reclaimable pages per BDI
Message-Id: <20070421025521.8d77072e.akpm@linux-foundation.org>
In-Reply-To: <20070420155503.222304356@chello.nl>
References: <20070420155154.898600123@chello.nl>
	<20070420155503.222304356@chello.nl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 17:52:01 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Count per BDI reclaimable pages; nr_reclaimable = nr_dirty + nr_unstable.

hm.  Aggregating dirty and unstable at inc/dec time is a bit kludgy.  If
later on we want to know just "dirty" then we're in trouble.

I can see the logic behind it though.

Perhaps one could have separate BDI_DIRTY and BDI_UNSTABLE and treat them
separately at inc/dec time, but give them the same numerical value, so
they in fact refer to the same counter.  That's kludgy too.
