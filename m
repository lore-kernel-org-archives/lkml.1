Return-Path: <linux-kernel-owner+w=401wt.eu-S1759905AbXEaXlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905AbXEaXlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 19:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbXEaXl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 19:41:29 -0400
Received: from holomorphy.com ([66.93.40.71]:40053 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbXEaXl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 19:41:28 -0400
Date: Thu, 31 May 2007 16:41:54 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 9/9] Scheduler profiling - Use conditional calls
Message-ID: <20070531234154.GL6909@holomorphy.com>
References: <20070530140025.917261793@polymtl.ca> <20070530140229.811672406@polymtl.ca> <20070530205927.GE6909@holomorphy.com> <20070531211258.GB904@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531211258.GB904@Krystal>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 10:00:34AM -0400, Mathieu Desnoyers wrote:
>>> +	if (prof_on)
>>> +		BUG_ON(cond_call_arm("profile_on"));

* William Lee Irwin III (wli@holomorphy.com) wrote:
>> What's the point of this BUG_ON()? The condition is a priori impossible.

On Thu, May 31, 2007 at 05:12:58PM -0400, Mathieu Desnoyers wrote:
> Not impossible: hash_add_cond_call() can return -ENOMEM if kmalloc lacks
> memory.

Shouldn't it just propagate the errors like anything else instead of
going BUG(), then? One can easily live without profiling if the profile
buffers should fail to be allocated e.g. due to memory fragmentation.

These things all have to handle errors for hotplugging anyway AIUI.


-- wli
