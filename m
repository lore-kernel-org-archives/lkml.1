Return-Path: <linux-kernel-owner+w=401wt.eu-S932658AbXAWCYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbXAWCYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 21:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932647AbXAWCYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 21:24:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932658AbXAWCYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 21:24:54 -0500
Message-ID: <45B5703E.5010400@redhat.com>
Date: Mon, 22 Jan 2007 21:17:34 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Balbir Singh <balbir@in.ibm.com>, Andrea Arcangeli <andrea@suse.de>,
       Niki Hammler <mailinglists@nobaq.net>, linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: Why active list and inactive list?
References: <45B55286.5060909@nobaq.net> <20070123003939.GY13798@opteron.random> <45B56575.10807@in.ibm.com> <Pine.LNX.4.64.0701221737510.30455@schroedinger.engr.sgi.com> <45B569A4.3010006@redhat.com> <Pine.LNX.4.64.0701221801420.30595@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0701221801420.30595@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Mon, 22 Jan 2007, Rik van Riel wrote:
> 
>> It would be really nice if we came up with a page replacement
>> algorithm that did not need many extra heuristics to make it
>> work...
> 
> I guess the "clock" type algorithms are the most promising in that 
> area. What happened to all those advanced page replacement endeavors? 
> What is the most promising of those? You seem to have done a lot of work 
> on those.

CLOCK-Pro seems the most promising algorithm, because it can
act well both as a first level cache (operating system running
applications) and as a second level cache (operating system
running as a file server), because it tracks both recency and
frequency well.

However, there are a few unanswered questions on clock-pro.

The big one is how we are to do some background aging in a
clock-pro system, so referenced bits don't just pile up when
the VM has enough memory - otherwise we might not know the
right pages to evict when a new process starts up and starts
allocating lots of memory.

At least we've solved the problems of keeping track of the
recently evicted pages in a cheap way, and balancing the
pressure/hotness of different caches against each other.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
