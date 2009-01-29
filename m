Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbZA2Bnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbZA2Bnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 20:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbZA2Bnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 20:43:42 -0500
Received: from ozlabs.org ([203.10.76.45]:60113 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbZA2Bnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 20:43:41 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Date: Thu, 29 Jan 2009 12:13:32 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <200901282332.29429.rusty@rustcorp.com.au> <20090128114440.77abc1b2.akpm@linux-foundation.org>
In-Reply-To: <20090128114440.77abc1b2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901291213.32959.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009 06:14:40 Andrew Morton wrote:
> It's vulnerable to the same deadlock, I think?  Suppose we have:
...
> - A calls work_on_cpu() and takes woc_mutex.
> 
> - Before function_which_takes_L() has started to execute, task B takes L
>   then calls work_on_cpu() and task B blocks on woc_mutex.
> 
> - Now function_which_takes_L() runs, and blocks on L

Agreed, but now it's a fairly simple case.  Both sides have to take lock L, and both have to call work_on_cpu.

Workqueues are more generic and widespread, and an amazing amount of stuff gets called from them.  That's why I felt uncomfortable with removing the one known problematic caller.

Thanks,
Rusty.
