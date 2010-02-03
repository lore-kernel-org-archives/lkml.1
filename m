Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845Ab0BCUMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 15:12:37 -0500
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:49505 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757777Ab0BCUMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 15:12:35 -0500
From: Frans Pop <elendil@planet.nl>
To: David Rientjes <rientjes@google.com>
Subject: Re: Improving OOM killer
Date: Wed, 3 Feb 2010 21:12:30 +0100
User-Agent: KMail/1.9.9
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
       l.lunak@suse.cz, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, jkosina@suse.cz,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <201002012302.37380.l.lunak@suse.cz> <201002032029.34145.elendil@planet.nl> <alpine.DEB.2.00.1002031141350.27853@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1002031141350.27853@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002032112.33908.elendil@planet.nl>
X-OriginalArrivalTime: 03 Feb 2010 20:12:34.0108 (UTC) FILETIME=[38E39FC0:01CAA50D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 February 2010, David Rientjes wrote:
>  - we have always exported OOM_DISABLE, OOM_ADJUST_MIN, and
> OOM_ADJUST_MAX via include/oom.h so that userspace should use them
> sanely.  Setting a particular oom_adj value for anything other than
> OOM_DISABLE means the score will be relative to other system tasks, so
> its a value that is typically calibrated at runtime rather than static,
> hardcoded values.

That doesn't take into account:
- applications where the oom_adj value is hardcoded to a specific value
  (for whatever reason)
- sysadmin scripts that set oom_adj from the console

I would think that oom_adj is a documented part of the userspace ABI and 
that the change you propose does not fit the normal backwards 
compatibility requirements for exposed tunables.

I think that at least any user who's currently setting oom_adj to -17 has a 
right to expect that to continue to mean "oom killer disabled". And for 
any other value they should get a similar impact to the current impact, 
and not one that's reduced by a factor 66.

> We could reuse /proc/pid/oom_adj for the new heuristic by severely
> reducing its granularity than it otherwise would by doing
> (oom_adj * 1000 / OOM_ADJUST_MAX), but that will eventually become
> annoying and much more difficult to document.

Probably quite true, but maybe unavoidable if one accepts the above.

But I'll readily admit I'm not the final authority on this.

Cheers,
FJP
