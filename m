Return-Path: <linux-kernel-owner+w=401wt.eu-S932669AbXAWCvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbXAWCvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 21:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932671AbXAWCvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 21:51:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932669AbXAWCvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 21:51:38 -0500
Message-ID: <45B5780C.8010002@redhat.com>
Date: Mon, 22 Jan 2007 21:50:52 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Balbir Singh <balbir@in.ibm.com>, Andrea Arcangeli <andrea@suse.de>,
       Niki Hammler <mailinglists@nobaq.net>, linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: Why active list and inactive list?
References: <45B55286.5060909@nobaq.net> <20070123003939.GY13798@opteron.random> <45B56575.10807@in.ibm.com> <Pine.LNX.4.64.0701221737510.30455@schroedinger.engr.sgi.com> <45B569A4.3010006@redhat.com> <Pine.LNX.4.64.0701221801420.30595@schroedinger.engr.sgi.com> <45B5703E.5010400@redhat.com> <Pine.LNX.4.64.0701221837210.30653@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0701221837210.30653@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Mon, 22 Jan 2007, Rik van Riel wrote:
> 
>> The big one is how we are to do some background aging in a
>> clock-pro system, so referenced bits don't just pile up when
>> the VM has enough memory - otherwise we might not know the
>> right pages to evict when a new process starts up and starts
>> allocating lots of memory.
> 
> There are two bad choices right?
> 
> 1. Scan for reference bits
> 
>    Bad because we may have to scan quite a bit without too much
>    result. LRU allows us to defer this until memory is tight.
>    Any such scan will pollute the cache and cause a stall of
>    the app. You really do not want this for a realtime system.
> 
> 2. Take faults on reference and update the page state.
>    Bad because this means a fault if the reference bit
>    has not been set. Could be many faults.
> 
> Clock pro really requires 2 right? So lots of additional page faults?

Nope, the faults are not required.

I suspect you're confused with the part where it keeps track
of recently evicted (not resident in RAM at all) pages. That
kind of info is common in database replacement schemes, but
not in general purpose OS memory management.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
