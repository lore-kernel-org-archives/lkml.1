Return-Path: <linux-kernel-owner+w=401wt.eu-S1750891AbXBSKpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750891AbXBSKpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbXBSKpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:45:11 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:53635 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbXBSKpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:45:09 -0500
Message-ID: <45D97FAD.9070009@in.ibm.com>
Date: Mon, 19 Feb 2007 16:15:01 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net, xemul@sw.ru,
       linux-mm@kvack.org, menage@google.com, svaidy@linux.vnet.ibm.com,
       devel@openvz.org
Subject: Re: [RFC][PATCH][0/4] Memory controller (RSS Control)
References: <20070219065019.3626.33947.sendpatchset@balbir-laptop> <20070219005441.7fa0eccc.akpm@linux-foundation.org> <aec7e5c30702190116j26efcba3oe5223584f99ac25a@mail.gmail.com>
In-Reply-To: <aec7e5c30702190116j26efcba3oe5223584f99ac25a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Damm wrote:
> On 2/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Mon, 19 Feb 2007 12:20:19 +0530 Balbir Singh <balbir@in.ibm.com> 
>> wrote:
>>
>> > This patch applies on top of Paul Menage's container patches (V7) 
>> posted at
>> >
>> >       http://lkml.org/lkml/2007/2/12/88
>> >
>> > It implements a controller within the containers framework for limiting
>> > memory usage (RSS usage).
> 
>> The key part of this patchset is the reclaim algorithm:
>>
>> Alas, I fear this might have quite bad worst-case behaviour.  One small
>> container which is under constant memory pressure will churn the
>> system-wide LRUs like mad, and will consume rather a lot of system time.
>> So it's a point at which container A can deleteriously affect things 
>> which
>> are running in other containers, which is exactly what we're supposed to
>> not do.
> 
> Nice with a simple memory controller. The downside seems to be that it
> doesn't scale very well when it comes to reclaim, but maybe that just
> comes with being simple. Step by step, and maybe this is a good first
> step?
> 

Thanks, I totally agree.

> Ideally I'd like to see unmapped pages handled on a per-container LRU
> with a fallback to the system-wide LRUs. Shared/mapped pages could be
> handled using PTE ageing/unmapping instead of page ageing, but that
> may consume too much resources to be practical.
> 
> / magnus

Keeping unmapped pages per container sounds interesting. I am not quite
sure what PTE ageing, will it look it up.


-- 
	Warm Regards,
	Balbir Singh
