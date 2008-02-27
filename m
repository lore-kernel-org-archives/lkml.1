Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYB0FtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYB0FtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 00:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbYB0Fs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 00:48:59 -0500
Received: from smtp-out.google.com ([216.239.45.13]:38854 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbYB0Fs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 00:48:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=rBnEhB6BIDp+5nek30IWk16QeVQV1DxYpBHae5ZzO1x7Vxjq2fRoIaDatx0VPnjpz
	qSVbR99lAJO9RMGtYMxvA==
Date: Tue, 26 Feb 2008 21:47:58 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC][PATCH] page reclaim throttle take2
In-Reply-To: <20080227143301.4252.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.00.0802262145410.31356@chino.kir.corp.google.com>
References: <47C4EF2D.90508@linux.vnet.ibm.com> <alpine.DEB.1.00.0802262115270.1799@chino.kir.corp.google.com> <20080227143301.4252.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, KOSAKI Motohiro wrote:

> > I disagree, the config option is indeed static but so is the NUMA topology 
> > of the machine.  It represents the maximum number of page reclaim threads 
> > that should be allowed for that specific topology; a maximum should not 
> > need to be redefined with yet another sysctl and should remain independent 
> > of various workloads.
> 
> ok.
> 
> > However, I would recommend adding the word "MAX" to the config option.
> 
> MAX_PARALLEL_RECLAIM_TASK is good word?
> 

I'd use _THREAD instead of _TASK, but I'd also wait for Balbir's input 
because perhaps I missed something in my original analysis that this 
config option represents only the maximum number of concurrent reclaim 
threads and other heuristics are used in addition to this that determine 
the exact number of threads depending on VM strain.

		David
