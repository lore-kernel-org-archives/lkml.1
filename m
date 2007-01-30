Return-Path: <linux-kernel-owner+w=401wt.eu-S964923AbXA3LeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964923AbXA3LeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 06:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965114AbXA3LeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 06:34:09 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:48349 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964923AbXA3LeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 06:34:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=1+9b8lMtlye3JlgVeEHfXBc4YcX50Brvy/0hZzl6hGJAu3eKoD+BjQgfMZ2jbu9q6qHqX3D/27s0p5IvFbdEbq7kE9Myl5TyYxcQ85sznxY6dnSq3inWJLQipnxu9HCqNuYm19m0WP4J0WKmm3FHRN2hFSBP94JCoNBiYnfNiyQ=  ;
X-YMail-OSG: ttLxPZwVM1nN02nVo5OBw48i010GjEOw1bbCwCPCJF3V6DvkF1skvQ.basLZLNz8nuphZLTb5IpqWXFziEvqHewHGf3oEJ3R2vzjYRaiDc1FosIDc9GEyHMXrnEwI_GfGNMBUDW2IqYjB5Q-
Message-ID: <45BF2D1E.3020207@yahoo.com.au>
Date: Tue, 30 Jan 2007 22:33:50 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Howard Chu <hyc@symas.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: swap map
References: <45BF2823.2090005@symas.com> <20070130112024.GA18705@infradead.org>
In-Reply-To: <20070130112024.GA18705@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, Jan 30, 2007 at 03:12:35AM -0800, Howard Chu wrote:
> 
>>In the it-would-be-nice department... While I was twiddling with swappiness 
>>and benchmarking some code, I thought it would be pretty cool if there was 
>>a node in /proc/<pid> that would show which pages of a process are resident 
>>or nonresident. I'm not sure that it would be useful very often, but I was 
>>thinking one could get a snapshot of that, correlated with traces from a 
>>malloc profiler, to show what portions of a program's memory usage was in 
>>active use vs idle.
> 
> 
> That's be a remote mincore().  This should be more or less trivial,
> do_mincore would need a mm_struct argument instead of always using
> current->mm and we'd need a simple seq_file interface iterating over it.
> 
> Any volunteers?

Well the first thing needed is an mincore that actually works for anonymous
memory!

I've implemented some fixups in that department, which should get merged
into 2.6.21. That reminds me: I'll send the patch to linux-mm for review...

We cannot get real atomic snapshots in general, but I don't think that would
be a problem if you are just doing some profiling.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
