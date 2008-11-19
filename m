Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYKSMN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYKSMN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 07:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbYKSMKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 07:10:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44040 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbYKSMKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 07:10:06 -0500
Date: Wed, 19 Nov 2008 07:10:02 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/7] Porting dynmaic ftrace to PowerPC
In-Reply-To: <20081119105719.GA21533@elte.hu>
Message-ID: <alpine.DEB.1.10.0811190650460.20272@gandalf.stny.rr.com>
References: <20081116212428.938752312@goodmis.org> <18720.42209.880409.297291@cargo.ozlabs.ibm.com> <alpine.DEB.1.10.0811171035530.2919@gandalf.stny.rr.com> <alpine.DEB.1.10.0811180853390.15003@gandalf.stny.rr.com> <18723.31762.522696.647294@cargo.ozlabs.ibm.com>
 <alpine.DEB.1.10.0811182150530.14914@gandalf.stny.rr.com> <20081119092723.GC22309@elte.hu> <18723.60578.179210.736789@cargo.ozlabs.ibm.com> <20081119105719.GA21533@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 19 Nov 2008, Ingo Molnar wrote:
> 
> Maybe Steve could do the following trick: create a Linus -git based 
> branch that uses the new APIs but marks ppc's ftrace as "depends 0" in 
> the powerpc Kconfig. (the new ftrace.c wont build)

There's only two generic commits that need to be added for the PowerPC 
code to work.

  ftrace: pass module struct to arch dynamic ftrace functions
  ftrace: allow NULL pointers in mcount_loc

I've already ported them to mainline to test PowerPC there.
Paul could use these two versions and keep ftrace in a separate branch in 
his tree. This way all the PowerPC code will be there, and actually can be 
tested. They may still hit the same bugs that we have fixed in tip, but 
those should all be minor, since any major bug is already in mainline or 
on its way.

> 
> You could pull that tree into the powerpc tree and everything should 
> still work fine in PPC - sans ftrace.
> 
> In tip/tracing we'd merge it too (these commits will never be 
> rebased), and we'd also remove the depends 0 from the powerpc Kconfig. 
> That sole change wont conflict with anything powerpc.
> 
> It would all play out just fine in linux-next: we'd have both the 
> latest powerpc bits and the latest ftrace bits on powerpc. You could 
> test the non-ftrace impact of Steve's changes in the powerpc tree as 
> well and have it all part of your usual workflow.
> 
> The 2.6.29 merge window would be trouble-free as well: since the 
> sha1's are the same, any of the trees can be merged upstream without 
> having to wait for the other one and without creating conflicts or 
> other trouble for the other one.
> 
> Hm?

If Paul uses the ported two generic commits, then he would need to keep 
that in a separate branch that will never go upstream. He could pull in 
the other PowerPC patches and do as you said, keep the depend off.

I can make two branches that Paul could pull from. One would have this 
code disabled in the config, and just be the PowerPC port. Although, we 
would need to figure out the best way to keep it disabled. Disable it 
after the patches? The patches themselve enable it.

And then I could make another branch with the back port of the two commits 
that Paul would never push upstream. This would allow for the PowerPC guys 
to test the code in their tree without waiting for it. We just need to 
trust that Paul will not push those commits ;-)

Actually, I can change the subject of those commits to have at the 
beginning:

   NOT FOR UPSTREAM ftrace: ....

What do you guys think?

-- Steve

