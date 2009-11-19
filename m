Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbZKSUJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbZKSUJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 15:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbZKSUJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 15:09:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754360AbZKSUJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 15:09:00 -0500
Date: Thu, 19 Nov 2009 12:06:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: rostedt@goodmis.org, David Daney <ddaney@caviumnetworks.com>,
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
In-Reply-To: <4B05A16D.1050807@zytor.com>
Message-ID: <alpine.LFD.2.00.0911191157430.2793@localhost.localdomain>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>  <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>  <20091119072040.GA23579@elte.hu>  <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain> 
 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>  <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>  <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain>  <1258653562.22249.682.camel@gandalf.stny.rr.com> 
 <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com>  <4B058CCD.8050605@redhat.com>  <alpine.LFD.2.00.0911191039470.2793@localhost.localdomain>  <alpine.LFD.2.00.0911191041471.2793@localhost.localdomain>  <alpine.LFD.2.00.0911191047350.2793@localhost.localdomain>
  <4B05982B.6060200@caviumnetworks.com> <1258658886.22249.874.camel@gandalf.stny.rr.com> <4B05A16D.1050807@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Nov 2009, H. Peter Anvin wrote:
> 
> Calling the profiler immediately at the entry point is clearly the more
> sane option.  It means the ABI is well-defined, stable, and independent
> of what the actual function contents are.  It means that ABI isn't the
> normal C ABI (the __fentry__ function would have to preserve all
> registers), but that's fine...

As far as I know, that's true of _mcount already: it's not a normal ABI 
and is rather a highly architecture-specific special case to begin with. 
At least ARM has some (several?) special mcount calling conventions, 
afaik.

(And then ARM people use __attribute__((naked)) and insert the code by 
inline asm, or something. That seems to be "standard" in the embedded 
world, where they often do even stranger things than we do in the 
kernel. At least our low-level system call and interrupt handlers are 
written as assembly language - the embedded world seems to commonly 
write them as C functions with magic attributes and inline asm).

		Linus
