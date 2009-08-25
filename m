Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbZHYSfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbZHYSfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbZHYSfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:35:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:54369 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755496AbZHYSfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:35:52 -0400
Message-ID: <4A942ED7.10109@kernel.org>
Date: Tue, 25 Aug 2009 11:35:03 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ravikiran G Thirumalai <kiran@scalex86.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, shai@scalex86.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
References: <20090824182659.GA6842@localdomain> <4A932809.1000103@kernel.org> <20090825012632.GB6842@localdomain> <4A9372A1.9090905@kernel.org> <20090825171716.GC6456@localdomain> <20090825181500.GB3277@elte.hu>
In-Reply-To: <20090825181500.GB3277@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
> 
>> On Mon, Aug 24, 2009 at 10:12:01PM -0700, Yinghai Lu wrote:
>>> Ravikiran G Thirumalai wrote:
>>>> On Mon, Aug 24, 2009 at 04:53:45PM -0700, Yinghai Lu wrote:
>>>>> Ravikiran G Thirumalai wrote:
>>>>>> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
>>>>>> Cc: Yinghai Lu <yinghai@kernel.org>
>>>>>>
>>>> Why?  The specs seem to indicate otherwise unless I am mistaken --
>>>> Intel  systems programming guide, Vol 3A Part1, chapter 7 section
>>>> 7.5.5 - Identifying Logical Processors in a MP system:
>>>> <quote>
>>>> After the BIOS has completed the MP initialization protocol, each logical
>>>> processor can be uniquely identified by its local APIC ID. Software can
>>>> access these APIC IDs in either of the following ways
>>>> </quote>
>>>> phys_pkg_id() indicates that the logical package id is being looked up,
>>>> so local apic id should be used here no?
>>>> What am I missing?
>>> initial apic id : it can not changed, there is fixed mapping from that to physical processor id aka socket id / node id.
>>>
>>> apic id: could be changed by BIOS to any value. there is no good way to get phys_pkg_id from that.
>>>
>> But BIOS is supposed to change it to a sane value.  Until 2.6.30, 
>> local apic id has been used to get phys_pkg_id for the 'flat' 
>> apics!  What changed?  Was this changed for a BIOS bug?  Even the 
>> intel books seem to indicate local apic usage!
> 
> We should revert to the .30 behavior unless there's a good reason 
> (even in that case we'll solve the regression and do a workaround 
> for vSMP). Yinghai?

we should stop overloading phys_pkg_id to get physical processor id (socket id ?) and apic id.

we need to find out what vSMP initial apic id looks like. and have one better phys_pkg_id for it.

otherwise we have problem with intel system that have apic id changing by BIOS too.

YH
