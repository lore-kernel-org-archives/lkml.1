Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbXFUM2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbXFUM2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 08:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbXFUM2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 08:28:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34428 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754865AbXFUM2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 08:28:34 -0400
Date: Thu, 21 Jun 2007 05:28:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie,
       kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com
Subject: Re: [PATCH 7/7] Compact memory directly by a process when a
 high-order allocation fails
Message-Id: <20070621052813.ac93e12e.akpm@linux-foundation.org>
In-Reply-To: <20070618093042.7790.30669.sendpatchset@skynet.skynet.ie>
References: <20070618092821.7790.52015.sendpatchset@skynet.skynet.ie>
	<20070618093042.7790.30669.sendpatchset@skynet.skynet.ie>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 18 Jun 2007 10:30:42 +0100 (IST) Mel Gorman <mel@csn.ul.ie> wrote:
> +
> +			/*
> +			 * It's a race if compaction frees a suitable page but
> +			 * someone else allocates it
> +			 */
> +			count_vm_event(COMPACTRACE);
> +		}

Could perhaps cause arbitrarily long starvation.  A fix would be to free
the synchronously-compacted higher-order page into somewhere which is
private to this task (a new field in task_struct would be one such place).
