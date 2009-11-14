Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbZKNNeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbZKNNeJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 08:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbZKNNeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 08:34:08 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:7670 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbZKNNeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 08:34:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SIfh0aXLFfU2mSb662Lw22BbLCU4XFHk2bA0mHSxzX3rFYJT77jwADxRkt0HdmZv47
         qaDC7TOkeAyqHamemtTrU2TSVNRfswlaa24c340taNtlXbZnvTbXQ3ZERcW/3jNZm9bw
         oBRZAvdMqH3J/hqFNn67sbT2ciasU+1tMnPXw=
Date: Sat, 14 Nov 2009 14:34:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Avi Kivity <avi@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 5/6] hw-breakpoints: Arbitrate access to pmu following
	registers constraints
Message-ID: <20091114133409.GF5245@nowhere>
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com> <1257275474-5285-6-git-send-email-fweisbec@gmail.com> <19186.45014.502448.698606@cargo.ozlabs.ibm.com> <1257713781.13611.284.camel@pasglop> <20091112155413.GE5237@nowhere> <1258056038.2140.354.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258056038.2140.354.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 07:00:38AM +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2009-11-12 at 16:54 +0100, Frederic Weisbecker wrote:
> > >  - On one embedded core at least we have a case where the core has 4
> > > threads, but the data (4) and instruction (2) breakpoint registers are
> > > shared. The 'enable' bits are split so a given data breakpoint can be
> > > enabled only on some HW threads but that's about it.
> > > 
> > > I'm not sure if there's a realistic way to handle the later constraint
> > > though other than just not allowing use of the HW breakpoint function on
> > > those cores at all.
> > > 
> > > Ben.
> > 
> > 
> > Yeah this latter one is tricky. Not sure how to handle it either.
> > How are these hw-threads considered by the kernel core? As different
> > cpu? 
> 
> Yes.
> 
> So it basically looks like you have 4 data and 2 HW instruction breakpoint
> registers shared by 4 CPUs in a group :-)
> 
> Cheers,
> Ben.
> 
> 


That's not a simple situation :)
I guess we'll need to let powerpc handle the constraints from the arch.

