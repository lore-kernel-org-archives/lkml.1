Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbYIFIuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbYIFIuM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 04:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYIFIt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 04:49:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36577 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbYIFIt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 04:49:58 -0400
Date: Sat, 6 Sep 2008 10:53:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, Gary Hade <garyhade@us.ibm.com>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [RESEND] x86_64: add memory hotremove config option
Message-ID: <20080906085320.GE18288@one.firstfloor.org>
References: <20080905215452.GF11692@us.ibm.com> <20080906000154.GC18288@one.firstfloor.org> <20080906153855.7260.E1E9C6FF@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080906153855.7260.E1E9C6FF@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2008 at 04:06:38PM +0900, Yasunori Goto wrote:
> > not.
> > 
> > This means I don't see a real use case for this feature.
> 
> I don't think its driver is almighty.
> IIRC, balloon driver can be cause of fragmentation for 24-7 system.

Sure the balloon driver can be likely improved too, it's just
that I don't think a balloon driver should call into the function
the original patch in the series hooked up.
> 
> In addition, I have heard that memory hotplug would be useful for reducing
> of power consumption of DIMM.

It's unclear that memory hotplug is the right model for DIMM power management.
The problem is that DIMMs are interleaved, so you again have to completely
free a quite large area. It's not much easier than node hotplug.

> I have to admit that memory hotplug has many issues, but I would like to

Let's call it "node" or "hardware" memory hot unplug, not that
anyone confuses it with the easier VM based hot unplug or the really
easy hotadd.

> solve them step by step.

The question is if they are even solvable in a useful way.
I'm not sure it's that useful to start and then find out
that it doesn't work anyways.

-Andi

