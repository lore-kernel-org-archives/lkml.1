Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbYKND21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbYKND21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 22:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYKND2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 22:28:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232AbYKND2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 22:28:18 -0500
Date: Thu, 13 Nov 2008 19:27:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm] vmscan: bail out of page reclaim after
 swap_cluster_max pages
Message-Id: <20081113192729.7d8eb133.akpm@linux-foundation.org>
In-Reply-To: <20081113171208.6985638e@bree.surriel.com>
References: <20081113171208.6985638e@bree.surriel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 17:12:08 -0500 Rik van Riel <riel@redhat.com> wrote:

> Sometimes the VM spends the first few priority rounds rotating back
> referenced pages and submitting IO.  Once we get to a lower priority,
> sometimes the VM ends up freeing way too many pages.
> 
> The fix is relatively simple: in shrink_zone() we can check how many
> pages we have already freed and break out of the loop.
> 
> However, in order to do this we do need to know how many pages we already
> freed, so move nr_reclaimed into scan_control.

There was a reason for not doing this, but I forget what it was.  It might require
some changelog archeology.  iirc it was to do with balancing scanning rates
between the various things which we scan.
