Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbZHYThU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbZHYThU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbZHYThT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:37:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:48832 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756100AbZHYThS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:37:18 -0400
Message-ID: <4A943D37.4030604@kernel.org>
Date: Tue, 25 Aug 2009 12:36:23 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ravikiran G Thirumalai <kiran@scalex86.org>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       shai@scalex86.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
References: <20090824182659.GA6842@localdomain> <4A932809.1000103@kernel.org> <20090825012632.GB6842@localdomain> <4A9372A1.9090905@kernel.org> <20090825171716.GC6456@localdomain> <20090825181500.GB3277@elte.hu> <20090825183130.GA5806@lenovo> <4A943290.5080606@kernel.org> <20090825192757.GE6456@localdomain>
In-Reply-To: <20090825192757.GE6456@localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ravikiran G Thirumalai wrote:
> On Tue, Aug 25, 2009 at 11:50:56AM -0700, Yinghai Lu wrote:
>> Cyrill Gorcunov wrote:
>>
>> initial apic id and apic id could be different.
>>
>> and we should use initial apic id to get correct phys pkg id in case BIOS set crazy apic id.
>>
> 
> Is there a specific bug we are fixing here?  Again, this behavior was
> present from atleast 2.6.15-2.6.30 on 'flat' and older 'cluster' apics, and intel
> documentation suggests local apic be used.  Is there a specific bios bug
> that is being fixed?
> 
> (The BIOS is not supposed to set a crazy apic ID.  The BIOS is buggy in that

we can not stop BIOS doing crazy thing.

for AMD 8 socket 4 cores system. BSP apic id : 4 or 8, and initial apic id is 0:

with apic id in phys_pkg_id, will get pkg id: 1, 2, ...

with initial apic id will get pkg id: 0, 1, 2, 3.

when I was working on LinuxBIOS, I did have one porting to have 
BSP: 0
AP: start from 5, 6, 7...
that will have strange in pkg_id.

YH
