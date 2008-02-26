Return-Path: <linux-kernel-owner+w=401wt.eu-S1765467AbYBZVjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765467AbYBZVjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759282AbYBZVjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:39:47 -0500
Received: from relay2.sgi.com ([192.48.171.30]:40489 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758188AbYBZVjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:39:46 -0500
Date: Tue, 26 Feb 2008 15:39:44 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/6] mempolicy: add MPOL_F_STATIC_NODES flag
Message-Id: <20080226153944.025bf1cb.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802261253510.10790@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com>
	<20080226115627.681dafb9.pj@sgi.com>
	<alpine.DEB.1.00.0802261253510.10790@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> No reader is going to understand immediately what 'mode', 'mode_flags', 
> and 'flags' are if you only provide a single line of the code like that. 

Duh - of course not.  I only presented that line to demonstrate that all
three words 'mode', 'mode_flags', and 'flags' appeared in the same context.

> It becomes rather obvious what they represent when you read the entire 
> sys_mbind() implementation,

How about picking less vacuous names than variations of mode and flag,
so that it's easier for the reader to distinguish without having to
read and understand an entire chunk of code first.

> This is a natural implementation detail to accomodate your insistance

My patch for this had explicit bit fields, which made the names clearer:

+       int mask_opts_rel:1;    /* c.original_mask is relative */
+       int mask_opts_abs:1;    /* c.original_mask is absolute */
+       /* if neither rel nor abs, then use c.latest_cpuset_mask */

You chose not to do that, which obfuscates what's going on.
Don't blame me that the result is obfuscated.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
