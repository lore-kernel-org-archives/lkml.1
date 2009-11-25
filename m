Return-Path: <linux-kernel-owner+w=401wt.eu-S934975AbZKYUQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934975AbZKYUQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 15:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932338AbZKYUQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 15:16:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51046 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbZKYUQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 15:16:52 -0500
Message-ID: <4B0D8FC1.1010608@zytor.com>
Date: Wed, 25 Nov 2009 12:12:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jakub Jelinek <jakub@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Haley <aph@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>,
       rostedt@goodmis.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Guenther <richard.guenther@gmail.com>, gcc <gcc@gcc.gnu.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL][v2.6.32] tracing/x86: Add check to detect GCC
 messing with mcount prologue
References: <1258736456.22249.1032.camel@gandalf.stny.rr.com> <4B06EF6F.2050507@redhat.com> <6dc9ffc80911220138y15bfa91agccf5c29f1c30e09a@mail.gmail.com> <4B0972C9.302@redhat.com> <6dc9ffc80911221530t38d83cf6je739743c8d756667@mail.gmail.com> <4B0BF119.4070704@redhat.com> <alpine.LFD.2.00.0911241555170.24119@localhost.localdomain> <20091124150604.GJ22813@hs20-bc2-1.build.redhat.com> <alpine.LFD.2.00.0911251604280.24119@localhost.localdomain> <20091125154452.GA9456@elte.hu> <20091125164434.GS22813@hs20-bc2-1.build.redhat.com>
In-Reply-To: <20091125164434.GS22813@hs20-bc2-1.build.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2009 08:44 AM, Jakub Jelinek wrote:
> 
> If you compile kernels 90%+ people out there run with -p on i?86/x86_64,
> then certainly coming up with a new gcc switch and new profiling ABI is
> desirable.  -p on i?86/x86_64 e.g. forces -fno-omit-frame-pointer, which
> makes code on these register starved arches significantly worse.
> Making GCC output profiling call before prologue instead of after prologue
> is a 4 liner in generic code and a few lines in target specific code.
> The important thing is that we shouldn't have 100 different profiling ABIs,
> so it is desirable to agree on something that will be generally useful not
> just for the kernel, but perhaps for other purposes.
> 

There is really just one that makes sense, which is providing the
ABI-defined entry state, which means intercepting at the point of entry.

Anything else is/was a mistake.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

