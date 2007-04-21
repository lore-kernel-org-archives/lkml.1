Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbXDUBh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbXDUBh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 21:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbXDUBh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 21:37:59 -0400
Received: from smtp-out.google.com ([216.239.45.13]:25177 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbXDUBh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 21:37:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=hfqutYC3bcBjVIxIYFHyfePK4jL1EBn7DENDHm/fOFrbcnPWHyovg/JM1EPmK+LSL
	tGFT8oPz5OKxFeGOYUeBA==
Message-ID: <46296ACD.3020402@google.com>
Date: Fri, 20 Apr 2007 18:37:17 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: akpm@osdl.org, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC 0/8] Cpuset aware writeback
References: <20070116054743.15358.77287.sendpatchset@schroedinger.engr.sgi.com> <45C2960B.9070907@google.com> <Pine.LNX.4.64.0702011815240.9799@schroedinger.engr.sgi.com> <46019F67.3010300@google.com> <Pine.LNX.4.64.0703211428430.4832@schroedinger.engr.sgi.com> <4626CEDA.7050608@google.com> <Pine.LNX.4.64.0704181948260.8743@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704181948260.8743@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Hmmmm.... Sorry. I got distracted and I have sent them to Kame-san who was 
> interested in working on them. 
>
> I have placed the most recent version at
> http://ftp.kernel.org/pub/linux/kernel/people/christoph/cpuset_dirty
>   

    Hi Christoph -- a few comments on the patches:

cpuset_write_dirty_map.htm

    In __set_page_dirty_nobuffers() you always call 
cpuset_update_dirty_nodes() but in __set_page_dirty_buffers() you call 
it only if page->mapping is still set after locking. Is there a reason 
for the difference? Also a question not about your patch: why do those 
functions call __mark_inode_dirty() even if the dirty page has been 
truncated and mapping == NULL?

cpuset_write_throttle.htm

    I noticed that several lines have leading spaces. I didn't check if 
other patches have the problem too.

    In get_dirty_limits(), when cpusets are configd you don't subtract 
highmen the same way that is done without cpusets. Is this intentional?

    It seems that dirty_exceeded is still a global punishment across 
cpusets. Should it be addressed?


    -- Ethan

