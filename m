Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbZAKEca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbZAKEca (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 23:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZAKEcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 23:32:22 -0500
Received: from relay2.sgi.com ([192.48.179.30]:45663 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751086AbZAKEcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 23:32:21 -0500
Message-ID: <49697646.6000701@sgi.com>
Date: Sat, 10 Jan 2009 20:32:06 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] kstat: modify kstat_irqs_legacy to be variable sized
References: <20090110223818.459493000@polaris-admin.engr.sgi.com> <20090110223819.033438000@polaris-admin.engr.sgi.com> <20090110225229.GE17917@elte.hu> <49692A50.7010402@sgi.com> <20090111010831.GD12885@elte.hu>
In-Reply-To: <20090111010831.GD12885@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
...
>>>> Allocate kstat_irqs_legacy based on nr_cpu_ids to deal with this
>>>> memory usage bump when NR_CPUS bumped from 128 to 4096:
>>>>
>>>>      8192   +253952    262144 +3100%  kstat_irqs_legacy(.bss)
>>>>
...
>>>> +	/* allocate based on nr_cpu_ids */
>>>> +	kstat_irqs_legacy = alloc_bootmem(NR_IRQS_LEGACY * nr_cpu_ids *
>>>> +					  sizeof(int));
...
>>> btw., while at it - dont we want to upgrade this to a 'long' (in a 
>>> separate commit)? Having more than 4 billion irqs after bootup is easily 
>>> possible.

Looking at this more closely, it seems it would be better to per_cpu_alloc
the legacy kstat_irqs as that would place the value being incremented on the
node of the cpu doing the incrementing. 

This, of course, would need the early per_cpu_alloc (in bootmem) that
the new cpu_alloc changes from Christoph and Rusty is providing.

Thanks,
Mike
