Return-Path: <linux-kernel-owner+w=401wt.eu-S1758132AbXFFIDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbXFFIDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 04:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbXFFIDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 04:03:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51735 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbXFFIDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 04:03:23 -0400
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
	globally
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Jackson <pj@sgi.com>, David Rientjes <rientjes@google.com>,
       ak@suse.de, clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070606010002.2ff6fc98.akpm@linux-foundation.org>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
	 <1181110846.7348.154.camel@twins>
	 <alpine.DEB.0.99.0706052334280.30783@chino.kir.corp.google.com>
	 <1181113753.7348.164.camel@twins>
	 <alpine.DEB.0.99.0706060012260.15316@chino.kir.corp.google.com>
	 <20070606003421.1107a8bf.pj@sgi.com>
	 <alpine.DEB.0.99.0706060042550.15316@chino.kir.corp.google.com>
	 <20070606005610.a8c783ce.pj@sgi.com>
	 <20070606010002.2ff6fc98.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 10:03:17 +0200
Message-Id: <1181116997.7348.170.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 01:00 -0700, Andrew Morton wrote:
> On Wed, 6 Jun 2007 00:56:10 -0700 Paul Jackson <pj@sgi.com> wrote:
> 
> > David wrote:
> > > That is, unless you can guarantee this type of problem will not happen again
> > 
> > Well, I certainly cannot guarantee that.
> 
> The only place I can think of where the kernel will sit there allocating
> huge amounts of memory like this is in readahead.

We just created one more, the execve string copy. However that uses
get_user_pages(), so if that gets fixed we're save there too.

