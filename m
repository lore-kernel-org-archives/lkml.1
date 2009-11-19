Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbZKSV1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbZKSV1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 16:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbZKSV1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 16:27:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbZKSV1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 16:27:49 -0500
Message-ID: <4B05B7AD.20500@redhat.com>
Date: Thu, 19 Nov 2009 14:25:01 -0700
From: Jeff Law <law@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: rostedt@goodmis.org, David Daney <ddaney@caviumnetworks.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
References: <viy9pk4xossnb6m2v041qu00.1258665258503@email.android.com>
In-Reply-To: <viy9pk4xossnb6m2v041qu00.1258665258503@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/09 14:14, H. Peter Anvin wrote:
> Hence a new unconstrained option...
>    
Not arguing against it, just noting there are targets where after the 
prologue mcount is mandated.   There's certainly hooks in GCC to do it 
both ways and if there's no clear need to use after-prologue on 
x86-linux, then before-prologue seems reasonable to me.

It's also the case that aligning stacks on the x86 and the poor code 
generated when used with profiling is an interaction I doubt anyone has 
looked at until now.  The result is definitely ugly and inefficient -- 
and there's something to be said for cleaning that up and at least 
marginally reducing the overhead of profiling.

Having said all that, I don't expect to personally be looking at the 
problem, given the list of other codegen issues that need to be looked 
at (reload in particular), profiling/stack interactions would be around 
87 millionth on my list.

jeff

