Return-Path: <linux-kernel-owner+w=401wt.eu-S965652AbXCBVUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965652AbXCBVUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965655AbXCBVUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:20:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965652AbXCBVUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:20:49 -0500
Message-ID: <45E894D7.2040309@redhat.com>
Date: Fri, 02 Mar 2007 16:19:19 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Bill Irwin <bill.irwin@oracle.com>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <clameter@engr.sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       npiggin@suse.de, mingo@elte.hu, jschopp@austin.ibm.com,
       arjan@infradead.org, torvalds@linux-foundation.org, mbligh@mbligh.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org> <45E842F6.5010105@redhat.com> <20070302085838.bcf9099e.akpm@linux-foundation.org> <Pine.LNX.4.64.0703020919350.16719@schroedinger.engr.sgi.com> <20070302093501.34c6ef2a.akpm@linux-foundation.org> <45E8624E.2080001@redhat.com> <20070302100619.cec06d6a.akpm@linux-foundation.org> <Pine.LNX.4.64.0703021012170.17676@schroedinger.engr.sgi.com> <45E86BA0.50508@redhat.com> <20070302211207.GJ10643@holomorphy.com>
In-Reply-To: <20070302211207.GJ10643@holomorphy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin wrote:
> On Fri, Mar 02, 2007 at 01:23:28PM -0500, Rik van Riel wrote:
>> With 32 CPUs diving into the page reclaim simultaneously,
>> each trying to scan a fraction of memory, this is disastrous
>> for performance.  A 256GB system should be even worse.
> 
> Thundering herds of a sort pounding the LRU locks from direct reclaim
> have set off the NMI oopser for users here.

Ditto here.

The main reason they end up pounding the LRU locks is the
swappiness heuristic.  They scan too much before deciding
that it would be a good idea to actually swap something
out, and with 32 CPUs doing such scanning simultaneously...

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
