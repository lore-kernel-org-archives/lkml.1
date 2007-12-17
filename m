Return-Path: <linux-kernel-owner+w=401wt.eu-S937551AbXLQX1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937551AbXLQX1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757037AbXLQX12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:27:28 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:47149 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbXLQX11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:27:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ItqLWtTyaCwfuBaU7JegcomTgR3FPp8RQqlGCNIIcmbdxA6J4nPfXgl8l+Kl3+Uf6j2h/rgdguKcTyxps7yXqqIXi3lxRYpX6na+jRKmiRR91X2niCKh/bqrcpuQ7C5U0e+q4hLL1dSgdVmakJelmJBG/U7rG6PqXbDAOcxCY18=
Subject: Re: FInal kprobes rollup patches
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>, srinivasa@in.ibm.com,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <hiramatu@sdl.hitachi.co.jp>,
       Rusty Lynch <rusty.lynch@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Keshavamurthy Anil S <anil.s.keshavamurthy@intel.com>
In-Reply-To: <476702C4.8070205@redhat.com>
References: <1197708350.898.87.camel@brick> <20071215085015.GA9720@elte.hu>
	 <1197709442.898.97.camel@brick> <20071215131204.GE9720@elte.hu>
	 <20071217142235.GA21379@linux.vnet.ibm.com>
	 <1197919234.23402.5.camel@brick>  <4766E9FC.7050101@redhat.com>
	 <1197927385.23402.41.camel@brick>  <4766EFA8.9070907@redhat.com>
	 <1197928823.23402.108.camel@brick>  <476702C4.8070205@redhat.com>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 15:27:33 -0800
Message-Id: <1197934053.23402.124.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-17 at 18:14 -0500, Masami Hiramatsu wrote:
> Hi Harvey,
> 
> Harvey Harrison wrote:
> > On Mon, 2007-12-17 at 16:52 -0500, Masami Hiramatsu wrote:
> >> Hi Harvey,
> >> Before porting, could you tell me what differences are important
> >> to you? We can discuss about it.
> > 
> > I've already ported it and sent it to you.  It's not really important to
> > me I just think my fine-grained patches may be of some use to see where
> > the differences between X86_32/64 ended up being.  Your patches end up
> > being just about entirely removal of ifdefs when rebased onto my
> > patches, so it's at least a good secondary check of your patches even
> > if mine don't go in.  Your patches end up being much smaller against
> > my version too.
> 
> OK, I'll review that.
> 
> >
> > I like my version slightly better because the remaining ifdefs (wrmsr,
> > etc) and others could be done in a few more small patches that are more
> > easily reviewable than your large final unification patch.
> 
> I agreed that your patches are including some goodness.
> So let us merge it into one.
> 
> 

OK, I'll take the last bits of your patches 5/6 that aren't already
cleaned up and send out a unified patchset for you to add your
acked/signed off by/reviewed by as appropriate.

These are:

-add stack_addr() macro
-I prefer the table defintion macros in mine as it avoids the need to
cast the pointer passed to test_bit, but if you want them
to be u32 as in your patch, I can change it.
-wrmsr/wrmsrl - use wrmsr() for both
-call is_IF_modifier with p->ainsn.insn in both
-check casting of jprobe_saved_sp, I get some compile warnings currently
with pointer comparisons to signed/unsigned types.

That will eliminate nearly all of the remaining ifdefs in my version,
let me work through this and I'll send out a set for review.

CHeers,

Harvey


