Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbZKDVCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbZKDVCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758162AbZKDVCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:02:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34970 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758155AbZKDVCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:02:16 -0500
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: Re: [MM] Remove rss batching from copy_page_range()
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1>
	<alpine.DEB.1.10.0911041415480.7409@V090114053VZO-1>
Date: Wed, 04 Nov 2009 22:02:20 +0100
In-Reply-To: <alpine.DEB.1.10.0911041415480.7409@V090114053VZO-1> (Christoph Lameter's message of "Wed, 4 Nov 2009 14:17:24 -0500 (EST)")
Message-ID: <87my3280mb.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux-foundation.org> writes:

> From: Christoph Lameter <cl@linux-foundation.org>
> Subject: Remove rss batching from copy_page_range()
>
> With per cpu counters in mm there is no need for batching
> mm counter updates anymore. Update counters directly while
> copying pages.

Hmm, but with all the inlining with some luck the local
counters will be in registers. That will never be the case
with the per cpu counters.

So I'm not sure it's really an improvement?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
