Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbZKSPwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbZKSPwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 10:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757224AbZKSPwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 10:52:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39483 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613AbZKSPwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 10:52:21 -0500
Message-ID: <4B056820.1050104@zytor.com>
Date: Thu, 19 Nov 2009 07:45:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain> <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org> <20091119072040.GA23579@elte.hu> <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain> <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain> <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2009 07:37 AM, Thomas Gleixner wrote:
> 
> modified function start on a handful of functions only seen with gcc
> 4.4.x on x86 32 bit:
> 
> 	push   %edi
> 	lea    0x8(%esp),%edi
> 	and    $0xfffffff0,%esp
> 	pushl  -0x4(%edi)
> 	push   %ebp
> 	mov    %esp,%ebp
> 	...
> 	call   mcount
> 

The real questions is why we're aligning the stack in the kernel.  It is
probably not what we want -- we don't use SSE for anything but a handful
of special cases in the kernel, and we don't want the overhead.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

