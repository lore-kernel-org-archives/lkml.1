Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074Ab0ATT30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab0ATT30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 14:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989Ab0ATT30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 14:29:26 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:55584 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab0ATT3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:29:25 -0500
Message-ID: <4B57597B.1020402@linux.vnet.ibm.com>
Date: Wed, 20 Jan 2010 11:28:59 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
References: <4B560ACD.4040206@linux.vnet.ibm.com> <20100120004430.GA23484@basil.fritz.box> <4B566131.6020300@linux.vnet.ibm.com> <20100120093555.GA24355@basil.fritz.box>
In-Reply-To: <20100120093555.GA24355@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/20/2010 1:35 AM, Andi Kleen wrote:
>> Yes, I agree.  Also it's easy to construct a system design that doesn't
>> have a hierarchical topology.  A simple example would be a cluster of 32
>> nodes, each of which is connected to its 31 neighbors.  Perhaps for the
>
> I doubt it's needed or useful to describe all details of an interconnect.
>

At this point, I don't see a need for that level of detail either.

> If detailed distance information is needed a simple table like
> the SLIT table exported by ACPI would seem easier to handle.
>

Thanks for the pointer.  I didn't know about the ACPI SLIT and SRAT tables until 
your post.  Having had a quick look at them, I don't think they'd be that 
helpful to us, at least at this point.

> But at least some degree of locality (e.g. "local memory controller")
> would make sense.

I think locality could be determined by looking at the device tree.  For 
example, a memory controller for a particular processor chip would be a 
subdirectory of that chip.

>
>> purposes of just enumerating PMUs, a tree might be sufficient, but it's not
>> clear to me that it is mathematically sufficient for all topologies, not to
>> mention if it's intuitive enough to use.  For example,
>> highly-interconnected components might require that PMU leaf nodes be
>> duplicated in multiple branches, i.e. PMU paths might not be unique in some
>> topologies.
>
> We already have cyclical graphs in sysfs using symlinks. I'm not
> sure they are all that easy to parse/handle, but at least they
> can be described.

Good point.

-- 
Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

