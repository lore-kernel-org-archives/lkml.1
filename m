Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbZHYRRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbZHYRRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 13:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbZHYRRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 13:17:20 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:55278 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbZHYRRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 13:17:19 -0400
Date: Tue, 25 Aug 2009 10:17:16 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, shai@scalex86.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
Message-ID: <20090825171716.GC6456@localdomain>
References: <20090824182659.GA6842@localdomain> <4A932809.1000103@kernel.org> <20090825012632.GB6842@localdomain> <4A9372A1.9090905@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9372A1.9090905@kernel.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 10:12:01PM -0700, Yinghai Lu wrote:
>Ravikiran G Thirumalai wrote:
>> On Mon, Aug 24, 2009 at 04:53:45PM -0700, Yinghai Lu wrote:
>>> Ravikiran G Thirumalai wrote:
>>>> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
>>>> Cc: Yinghai Lu <yinghai@kernel.org>
>>>>
>>>
>> 
>> Why?  The specs seem to indicate otherwise unless I am mistaken --
>> Intel  systems programming guide, Vol 3A Part1, chapter 7 section
>> 7.5.5 - Identifying Logical Processors in a MP system:
>> <quote>
>> After the BIOS has completed the MP initialization protocol, each logical
>> processor can be uniquely identified by its local APIC ID. Software can
>> access these APIC IDs in either of the following ways
>> </quote>
>> phys_pkg_id() indicates that the logical package id is being looked up,
>> so local apic id should be used here no?
>> What am I missing?
>
>initial apic id : it can not changed, there is fixed mapping from that to physical processor id aka socket id / node id.
>
>apic id: could be changed by BIOS to any value. there is no good way to get phys_pkg_id from that.
>

But BIOS is supposed to change it to a sane value.  Until 2.6.30, local apic
id has been used to get phys_pkg_id for the 'flat' apics!  What changed?  Was
this changed for a BIOS bug?  Even the intel books seem to indicate local
apic usage!
