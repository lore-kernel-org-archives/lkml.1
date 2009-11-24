Return-Path: <linux-kernel-owner+w=401wt.eu-S933623AbZKXRaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623AbZKXRaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 12:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933578AbZKXRaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 12:30:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42958 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933519AbZKXRae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 12:30:34 -0500
Subject: Re: [PATCH][GIT PULL][v2.6.32] tracing/x86: Add check to detect
 GCC messing with mcount prologue
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Andrew Haley <aph@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jakub Jelinek <jakub@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H.J. Lu" <hjl.tools@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Guenther <richard.guenther@gmail.com>, gcc <gcc@gcc.gnu.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <4B0C13F4.5090106@redhat.com>
References: <1258694593.22249.1012.camel@gandalf.stny.rr.com>
	 <1258736456.22249.1032.camel@gandalf.stny.rr.com>
	 <4B06EF6F.2050507@redhat.com>
	 <6dc9ffc80911220138y15bfa91agccf5c29f1c30e09a@mail.gmail.com>
	 <4B0972C9.302@redhat.com>
	 <6dc9ffc80911221530t38d83cf6je739743c8d756667@mail.gmail.com>
	 <4B0BF119.4070704@redhat.com>
	 <alpine.LFD.2.00.0911241555170.24119@localhost.localdomain>
	 <20091124150604.GJ22813@hs20-bc2-1.build.redhat.com>
	 <4B0BFC84.7070806@redhat.com>
	 <20091124153634.GK22813@hs20-bc2-1.build.redhat.com>
	 <4B0BFFD0.2080203@redhat.com> <4B0C0C12.7040907@zytor.com>
	 <4B0C13F4.5090106@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 24 Nov 2009 12:30:39 -0500
Message-Id: <1259083839.22249.1117.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 17:12 +0000, Andrew Haley wrote:
> H. Peter Anvin wrote:

> > If we're changing gcc anyway, then let's add the option of intercepting
> > the function at the point where the machine state is well-defined by
> > ABI, which is before the function stack frame is set up.
> 
> Hmm.  On the x86 I suppose we could just inject a naked call instruction,
> but not all aeches allow us to call anything before we've saved the return
> address.  Or are you talking x86 only?

Earlier in the GCC BUG thread we talked about this. Adding a __fentry__
call at the beginning of the function. This could be done for other
archs as well, but yes, the return address must be stored. For x86 it is
the easiest because it automatically stores the return address on the
stack (Andi already has a working patch I believe).

For other archs, Linus showed some examples:

http://lkml.org/lkml/2009/11/19/349

-- Steve


