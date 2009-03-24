Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbZCXDTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbZCXDTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 23:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZCXDTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 23:19:46 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:53189 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbZCXDTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 23:19:45 -0400
Date: Mon, 23 Mar 2009 20:19:25 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       shai@scalex86.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [rfc] [patch 1/2 ] Process private hash tables for private
	futexes
Message-ID: <20090324031925.GF7278@localdomain>
References: <20090321044637.GA7278@localdomain> <49C4AE64.4060400@cosmosbay.com> <20090322045414.GD7278@localdomain> <49C5F3FD.9010606@cosmosbay.com> <20090323202837.GE7278@localdomain> <49C805E3.4060808@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49C805E3.4060808@cosmosbay.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 10:57:55PM +0100, Eric Dumazet wrote:
>Ravikiran G Thirumalai a écrit :
>> 
[...]
>> Hmm!  How about
>> a) Reduce hash table size for private futex hash and increase hash table
>>    size for the global hash?
>> 
>> OR, better,
>> 
>> b) Since it is multiple spinlocks on the same cacheline which is a PITA
>>    here, how about keeping the global table, but just add a dereference
>>    to each hash slot, and interleave the adjacent hash buckets between
>>    nodes/cpus? So even without needing to  lose out memory from padding,
>>    we avoid false sharing on cachelines due to unrelated futexes hashing
>>    onto adjacent hash buckets?
>> 
>
>Because of jhash(), futex slots are almost random. No need to try to interleave
>them. Since you have a "cache line" of 4096 bytes, you need almost 4 pages
>per cpu to avoid in a statistical way false sharing.

How did you come up with that number?  So there is no way adjacent
cachelines will never ever be used in the global hash??
