Return-Path: <linux-kernel-owner+w=401wt.eu-S1760036AbZD1H1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036AbZD1H1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 03:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbZD1H1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 03:27:09 -0400
Received: from ultra7.eskimo.com ([204.122.16.70]:4280 "EHLO ultra7.eskimo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbZD1H1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 03:27:08 -0400
Date: Tue, 28 Apr 2009 00:26:19 -0700
From: Elladan <elladan@eskimo.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Elladan <elladan@eskimo.com>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>
Subject: Re: Swappiness vs. mmap() and interactive response
Message-ID: <20090428072619.GA29747@eskimo.com>
References: <20090428143019.EBBF.A69D9226@jp.fujitsu.com> <20090428063625.GA17785@eskimo.com> <20090428154835.EBC9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428154835.EBC9.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 03:52:29PM +0900, KOSAKI Motohiro wrote:
> Hi
> 
> > 3. cache limitation of memcgroup solve this problem?
> > 
> > I was unable to get this to work -- do you have some documentation handy?
> 
> Do you have kernel source tarball?
> Documentation/cgroups/memory.txt explain usage kindly.

Thank you.  My documentation was out of date.

I created a cgroup with limited memory and placed a copy command in it, and the
latency problem seems to essentially go away.  However, I'm also a bit
suspicious that my test might have become invalid, since my IO performance
seems to have dropped somewhat too.

So, am I right in concluding that this more or less implicates bad page
replacement as the culprit?  After I dropped vm caches and let my working set
re-form, the memory cgroup seems to be effective at keeping a large pool of
memory free from file pressure.

