Return-Path: <linux-kernel-owner+w=401wt.eu-S1751673Ab0ATGg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab0ATGg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 01:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324Ab0ATGgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 01:36:25 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:58195 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab0ATGgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 01:36:24 -0500
Date: Wed, 20 Jan 2010 12:06:20 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, ananth@in.ibm.com,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
Message-ID: <20100120063620.GA30109@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com>
 <4B545146.3080001@redhat.com>
 <20100118124419.GC1628@linux.vnet.ibm.com>
 <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com>
 <4B5459CA.9060603@redhat.com>
 <4B545ACF.40203@cs.helsinki.fi>
 <1263852957.2266.38.camel@localhost.localdomain>
 <4B556855.6040800@redhat.com>
 <1263923265.4998.28.camel@localhost.localdomain>
 <20100119180610.GA11005@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100119180610.GA11005@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker <fweisbec@gmail.com> [2010-01-19 19:06:12]:

> On Tue, Jan 19, 2010 at 09:47:45AM -0800, Jim Keniston wrote:
> > 
> > What does the code in the jumped-to vma do?  Is the instrumentation code
> > that corresponds to the uprobe handlers encoded in an ad hoc .so?
> 
> 
> Once the instrumentation is requested by a process that is not the
> instrumented one, this looks impossible to set a uprobe without a
> minimal voluntary collaboration from the instrumented process
> (events sent through IPC or whatever). So that looks too limited,
> this is not anymore a true dynamic uprobe.

I dont see a case where the thread being debugged refuses to place a
probe unless the process is exiting. The traced process doesnt decide
if it wants to be probed or not. There could be a slight delay from the
time the tracer requested to the time the probe is placed. But this
delay in only affecting the tracer and the tracee. This is in contract
to say stop_machine where the threads of other applications are also
affected.


