Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbZKSTyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbZKSTyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 14:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbZKSTyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 14:54:51 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:50260 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbZKSTyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 14:54:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kLEfBeFcscNRw1gvy+4b2Gu+uKm4ws93BDrzJqtQ7fr7BLaH4wpdZnueGmdEzpwjiE
         0cmxryq8IBB1v2mrr4vCOaTGipvbBhzMwmq3mDCriNG/5lAsrC3QinwTIznKAHUSAsxK
         ZpeHGOXuwsg/Eqc1KIZruQSyReattPPSavbxo=
MIME-Version: 1.0
In-Reply-To: <20091119194625.GE4967@nowhere>
References: <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
	 <1258653562.22249.682.camel@gandalf.stny.rr.com>
	 <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com>
	 <4B058CCD.8050605@redhat.com>
	 <alpine.LFD.2.00.0911191039470.2793@localhost.localdomain>
	 <alpine.LFD.2.00.0911191041471.2793@localhost.localdomain>
	 <alpine.LFD.2.00.0911191047350.2793@localhost.localdomain>
	 <4B05982B.6060200@caviumnetworks.com>
	 <1258658886.22249.874.camel@gandalf.stny.rr.com>
	 <20091119194625.GE4967@nowhere>
Date: Thu, 19 Nov 2009 20:54:56 +0100
Message-ID: <90baa01f0911191154x2ab208cbp2b094c91bbd144ca@mail.gmail.com>
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
From: Kai Tietz <ktietz70@googlemail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       David Daney <ddaney@caviumnetworks.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/19 Frederic Weisbecker <fweisbec@gmail.com>:
> I would really like this. So that we can forget about other possible
> further suprises due to sophisticated function prologues beeing before
> the mcount call.
>
> And I guess that would fix it in every archs.

My 5 cent for this, too.

> That said, Linus had a good point about the fact there might other uses
> of mcount even more tricky than what does the function graph tracer,
> outside the kernel, and those may depend on the strict ABI assumption
> that 4(ebp) is always the _real_ return address, and that through all
> the previous stack call. This is even a concern that extrapolates the
> single mcount case.
>
> So I wonder that actually the real problem is the lack of something that
> could provide this guarantee. We may need a -real-ra-before-fp (yeah
> I suck in naming).

There are, especially in windows world. We noticed that for example
the Sun's JDK (which is compiled by VC) can be used in gcc compiled
code only by -fno-omit-frame-pointer, as otherwise it fails badly
reasoned by wrong ebp accesses.

Kai

-- 
|  (\_/) This is Bunny. Copy and paste
| (='.'=) Bunny into your signature to help
| (")_(") him gain world domination
