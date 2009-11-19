Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbZKSVIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbZKSVIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 16:08:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbZKSVIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 16:08:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbZKSVID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 16:08:03 -0500
Message-ID: <4B05B32C.9020503@redhat.com>
Date: Thu, 19 Nov 2009 14:05:48 -0700
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
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>	 <20091119072040.GA23579@elte.hu>	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>	 <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>	 <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain>	 <1258653562.22249.682.camel@gandalf.stny.rr.com>	 <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com>	 <4B058CCD.8050605@redhat.com>	 <alpine.LFD.2.00.0911191039470.2793@localhost.localdomain>	 <alpine.LFD.2.00.0911191041471.2793@localhost.localdomain>	 <alpine.LFD.2.00.0911191047350.2793@localhost.localdomain>	 <4B05982B.6060200@caviumnetworks.com> <1258658886.22249.874.camel@gandalf.stny.rr.com> <4B05A16D.1050807@zytor.com>
In-Reply-To: <4B05A16D.1050807@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/09 12:50, H. Peter Anvin wrote:
>
> Calling the profiler immediately at the entry point is clearly the more
> sane option.  It means the ABI is well-defined, stable, and independent
> of what the actual function contents are.  It means that ABI isn't the
> normal C ABI (the __fentry__ function would have to preserve all
> registers), but that's fine...
>    
Note there are targets (even some old x86 variants) that required the 
profiling calls to occur after the prologue.  Unfortunately, nobody 
documented *why* that  was the case.   Sigh.

Jeff
