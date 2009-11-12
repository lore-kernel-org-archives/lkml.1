Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbZKLUEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbZKLUEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 15:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbZKLUEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 15:04:36 -0500
Received: from gate.crashing.org ([63.228.1.57]:51797 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbZKLUEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 15:04:35 -0500
Subject: Re: [PATCH 5/6] hw-breakpoints: Arbitrate access to pmu following
 registers constraints
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
In-Reply-To: <20091112155413.GE5237@nowhere>
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com>
	 <1257275474-5285-6-git-send-email-fweisbec@gmail.com>
	 <19186.45014.502448.698606@cargo.ozlabs.ibm.com>
	 <1257713781.13611.284.camel@pasglop>  <20091112155413.GE5237@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 07:00:38 +1100
Message-ID: <1258056038.2140.354.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-12 at 16:54 +0100, Frederic Weisbecker wrote:
> >  - On one embedded core at least we have a case where the core has 4
> > threads, but the data (4) and instruction (2) breakpoint registers are
> > shared. The 'enable' bits are split so a given data breakpoint can be
> > enabled only on some HW threads but that's about it.
> > 
> > I'm not sure if there's a realistic way to handle the later constraint
> > though other than just not allowing use of the HW breakpoint function on
> > those cores at all.
> > 
> > Ben.
> 
> 
> Yeah this latter one is tricky. Not sure how to handle it either.
> How are these hw-threads considered by the kernel core? As different
> cpu? 

Yes.

So it basically looks like you have 4 data and 2 HW instruction breakpoint
registers shared by 4 CPUs in a group :-)

Cheers,
Ben.


