Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbZKSSmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbZKSSmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZKSSmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:42:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53006 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbZKSSmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:42:35 -0500
Message-ID: <4B05904D.8050508@zytor.com>
Date: Thu, 19 Nov 2009 10:37:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Andrew Haley <aph@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>	 <20091119072040.GA23579@elte.hu>	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>	 <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>	 <4B058C76.9090609@redhat.com> <1258655585.22249.751.camel@gandalf.stny.rr.com>
In-Reply-To: <1258655585.22249.751.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2009 10:33 AM, Steven Rostedt wrote:
> 
> It has to align the entire stack? Why not just the variable within the
> stack?
> 

Because if the stack pointer isn't aligned, it won't know where it can
stuff the variable.  It has to pad *somewhere*, and since you may have
more than one such variable, the most efficient way -- and by far least
complex -- is for the compiler to align the stack when it sets up the
stack frame.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

