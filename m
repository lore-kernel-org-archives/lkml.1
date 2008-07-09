Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbYGIUz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbYGIUz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbYGIUzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:55:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37873 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751076AbYGIUzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:55:17 -0400
Message-ID: <487525B3.90904@sgi.com>
Date: Wed, 09 Jul 2008 13:55:15 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <20080709192822.GB4804@elte.hu>
In-Reply-To: <20080709192822.GB4804@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>>   * x86_64: Rebase per cpu variables to zero
>>
>>     Take advantage of the zero-based per cpu area provided above. Then 
>>     we can directly use the x86_32 percpu operations. x86_32 offsets 
>>     %fs by __per_cpu_start. x86_64 has %gs pointing directly to the 
>>     pda and the per cpu area thereby allowing access to the pda with 
>>     the x86_64 pda operations and access to the per cpu variables 
>>     using x86_32 percpu operations.
> 
> hm, have the binutils (or gcc) problems with this been resolved?
> 
> If common binutils versions miscompile the kernel with this feature then 
> i guess we cannot just unconditionally enable it. (My hope is that it's 
> not necessarily a binutils bug but some broken assumption of the kernel 
> somewhere.)
> 
> 	Ingo

Currently I'm using gcc-4.2.4.  Which are you using?

I labeled it "RFC" as it does not quite work without THREAD_ORDER bumped to 2.
And I believe the stack overflow is happening because of some interrupt
routine as it does not happen on our simulator.

After that is taken care of, I'll start regression testing earlier compilers.
I think someone mentioned that gcc-2.something was the minimum required...?

Thanks,
Mike
