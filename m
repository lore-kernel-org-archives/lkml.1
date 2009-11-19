Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbZKTAAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbZKTAAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 19:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942AbZKTAAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 19:00:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757789AbZKTAAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 19:00:42 -0500
Message-ID: <4B05DBBF.5000804@redhat.com>
Date: Thu, 19 Nov 2009 16:58:55 -0700
From: Jeff Law <law@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: "H. Peter Anvin" <hpa@zytor.com>, David Daney <ddaney@caviumnetworks.com>,
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
References: <viy9pk4xossnb6m2v041qu00.1258665258503@email.android.com> 	 <4B05B7AD.20500@redhat.com> <1258670580.22249.1002.camel@gandalf.stny.rr.com>
In-Reply-To: <1258670580.22249.1002.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/09 15:43, Steven Rostedt wrote:
> On Thu, 2009-11-19 at 14:25 -0700, Jeff Law wrote:
>
>    
>> Having said all that, I don't expect to personally be looking at the
>> problem, given the list of other codegen issues that need to be looked
>> at (reload in particular), profiling/stack interactions would be around
>> 87 millionth on my list.
>>      
> Is there someone else that can look at it?
>
>    
Unsure at the moment...  Like everyone else, GCC developers are busy and 
this probably isn't going to be a high priority item for anyone.


> Or at the very least, could you point us to where that code is, and one
> of us tracing folks could take a crack at switching hats to be a
> compiler writer (with the obvious prerequisite of drinking a lot of beer
> first, or is there a better drug to cope with the pain of writing gcc?).
>    
It _might_ be as easy as defining PROFILE_BEFORE_PROLOGUE in
gcc-<someversion>gcc/config/i386/linux.h & rebuilding GCC.

Based on comments elsewhere, the sun386i support may have used 
PROFILE_BEFORE_PROLOGUE in the past and thus the x86 backend may not 
need further adjustment.  That is obviously the ideal case.

If that appears to work for your needs, I'll volunteer to test it more 
thoroughly and assuming those tests look good shepherd it into the 
source tree.

Jeff
