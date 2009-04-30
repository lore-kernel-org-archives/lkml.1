Return-Path: <linux-kernel-owner+w=401wt.eu-S1763647AbZD3NvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763647AbZD3NvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763472AbZD3Nsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:48:47 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:41786 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763475AbZD3Nsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:48:46 -0400
Subject: Re: [RFC] Replace the watermark-related union in struct zone with
	a watermark[] array
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090430133524.GC21997@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
	 <1240408407-21848-19-git-send-email-mel@csn.ul.ie>
	 <alpine.DEB.2.00.0904221251350.14558@chino.kir.corp.google.com>
	 <20090427170054.GE912@csn.ul.ie>
	 <alpine.DEB.2.00.0904271340320.11972@chino.kir.corp.google.com>
	 <20090427205400.GA23510@csn.ul.ie>
	 <alpine.DEB.2.00.0904271400450.11972@chino.kir.corp.google.com>
	 <20090430133524.GC21997@csn.ul.ie>
Content-Type: text/plain
Date: Thu, 30 Apr 2009 06:48:20 -0700
Message-Id: <1241099300.29485.96.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-30 at 14:35 +0100, Mel Gorman wrote:
> I think what you're saying that you'd be ok with
> 
> zone_wmark_min(z)
> zone_wmark_low(z)
> zone_wmark_high(z)
> 
> and z->pages_mark[WMARK_MIN] =
> and z->pages_mark[WMARK_LOW] =
> and z->pages_mark[WMARK_HIGH] =
> 
> ?
> 
> Is that a significant improvement over what the patch currently does? To
> me, it seems more verbose.

Either way, there are _relatively_ few users.  From a quick cscope, it
appears setup_per_zone_pages_min() is really the heaviest user assigning
them.

Personally, I do like having the 'wmark' or something similar in the
function or structure member names.  But, I also like having the units
in there as well.  There's probably not room for both, though.  I'm fine
with the naming you have above.  The only thing I might consider is
removing 'zone_' from the function names since it's implied from the
variable name:

	min_wmark_pages(z)

The 'z->pages_mark[WMARK_*]' form is ugly, but it should be basically
restricted to use in setup_per_zone_pages_min().  I think that means we
don't need set_foo() functions because of a lack of use sites.

-- Dave

