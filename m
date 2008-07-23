Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbYGWRpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbYGWRpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 13:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYGWRpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 13:45:23 -0400
Received: from relay2.sgi.com ([192.48.171.30]:53766 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751394AbYGWRpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 13:45:22 -0400
Message-ID: <48876E2E.4000508@sgi.com>
Date: Wed, 23 Jul 2008 10:45:18 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Paul Jackson <pj@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/8] cpumask: Replace cpumask_of_cpu with cpumask_of_cpu_ptr
References: <20080715211429.454823000@polaris-admin.engr.sgi.com> <200807181530.10044.rusty@rustcorp.com.au> <48809DEB.5060104@sgi.com> <200807202003.31526.rusty@rustcorp.com.au>
In-Reply-To: <200807202003.31526.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
...
>> Another thought I had is perhaps cpumask.h should define something that
>> indicates a "huge NR_CPUS count" that is used globally to trigger things
>> like kmalloc of cpumask variables, instead of declaring them on the
>> stack...?  Or (as has been discussed in the past), maybe a new cpumask_t
>> type will be needed?
> 
> AFAICT the final answer has to be a get_cpu_mask()/put_cpu_mask(), which 
> sleeps and doesn't nest (so we can use a pool allocator).  Of course, that 
> kind of analysis is non-trivial, so I suggest that's not for this merge 
> window...
> 
> Want me to try something and see if it boots?
> Rusty.

Hi Rusty,

There are a number of occasions where a function declares a temporary cpumask_t
variable on the stack to hold (say) current->cpus_allowed.  I tried a couple of
options early on to a.) reserve one or two cpumask_t variables in the task
struct; and b.) reserve one or two cpumask_t variables per cpu.  Both had weird
consequences in some usages and since 4096 is *only* 512 bytes, it didn't seem
worth the effort.  Our next iteration will have NR_CPUS=16384 and therefore
removing all stack declared cpumask_t variables is highly desirable.

Your idea of a pool allocator is very interesting... ;-)

Thanks,
Mike
