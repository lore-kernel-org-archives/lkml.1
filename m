Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbYLYPrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbYLYPrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 10:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbYLYPrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 10:47:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44580 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbYLYPrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 10:47:01 -0500
Message-ID: <4953AAE5.4000708@redhat.com>
Date: Thu, 25 Dec 2008 17:46:45 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joerg.roedel@amd.com>,
       Benjamin Serebrin <benjamin.serebrin@amd.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Alexander Graf <agraf@suse.de>
Subject: Re: kvm vmload/vmsave vs tss.ist
References: <49539FD0.7070103@redhat.com> <20081225151757.GA25117@elte.hu>
In-Reply-To: <20081225151757.GA25117@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i think we should actually do #1 unconditionally.
>
> ISTs are bad for the native kernel too. They have various nasty 
> complications in the stack walker (and hence they _reduce_ reliability in 
> practice), and they are non-preemptible as well. Plus we have the 
> maximum-stack-footprint ftrace plugin now, which can remove any perception 
> about how bad the worst-case stack footprint is in practice.
>
> If it ever becomes an issue we could also soft-switch to a larger (per 
> CPU) exception stack from the exception handlers themselves. The 
> architectural stack footprint of the various critical exceptions are 
> calculatable and low - so we could switch away and get almost the kind of 
> separation that ISTs give. There's no deep reason to actually make use of 
> hw switched ISTs.
>
> So feel free to send a patch that just standardizes the critical 
> exceptions to use the regular kernel stack. (I havent actually tried this 
> but it should be relatively simple to implement. Roadblocks are possible.)
>   

Certainly.  There is provision for a debug stack that can be larger than 
the normal exception stack.  This is used for vectors 1 and 3.  If we 
wish to preserve this, we need to to manual stack switching.

Currently DEBUG_STKSZ is 8K, the same as the normal stack (compared to 
4K for the other execption stacks).  Do we need to implement stack 
switching for debug vectors?

-- 
error compiling committee.c: too many arguments to function

