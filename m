Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbZKSSdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbZKSSdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:33:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbZKSSdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:33:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50511 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbZKSSdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:33:01 -0500
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Andrew Haley <aph@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
In-Reply-To: <4B058C76.9090609@redhat.com>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>
	 <20091119072040.GA23579@elte.hu>
	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
	 <4B058C76.9090609@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 19 Nov 2009 13:33:05 -0500
Message-Id: <1258655585.22249.751.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-19 at 18:20 +0000, Andrew Haley wrote:

> OK, I found it.  There is a struct defined as
> 
> struct entry {
>  ...
> } __attribute__((__aligned__((1 << (4)))));
> 
> and then in timer_stats_update_stats you have a local variable of type
> struct entry:
> 
> void timer_stats_update_stats()
> {
>  spinlock_t *lock;
>  struct entry *entry, input;
> 
> So, gcc has to 16-align the stack pointer to satisfy the alignment
> for struct entry.

It has to align the entire stack? Why not just the variable within the
stack?

-- Steve


