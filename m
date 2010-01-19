Return-Path: <linux-kernel-owner+w=401wt.eu-S1755039Ab0ASSGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab0ASSGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 13:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459Ab0ASSGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 13:06:19 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:37339 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab0ASSGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 13:06:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Il9NpxrLH+MeXoXekBzUOwyMAFGbckpt/8ifgDz99tn/4S9uKN1dHEOC8iA3efMgNb
         5dU+0vzHBNmUuOd+l6+pPMnYYSX9f7On4LLEefrX8sm+9/aSjWxIX4RBoCUppfOEKuWP
         yHjeuEhKEb7ebUsaWv69o9HLyQSwifMDT9zDI=
Date: Tue, 19 Jan 2010 19:06:12 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jim Keniston <jkenisto@us.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, ananth@in.ibm.com,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
Message-ID: <20100119180610.GA11005@nowhere>
References: <4B544F8E.1080603@redhat.com> <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com> <4B545146.3080001@redhat.com> <20100118124419.GC1628@linux.vnet.ibm.com> <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com> <4B5459CA.9060603@redhat.com> <4B545ACF.40203@cs.helsinki.fi> <1263852957.2266.38.camel@localhost.localdomain> <4B556855.6040800@redhat.com> <1263923265.4998.28.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263923265.4998.28.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 09:47:45AM -0800, Jim Keniston wrote:
> > Do you have plans for a variant 
> > that's completely in userspace?
> 
> I don't know of any such plans, but I'd be interested to read more of
> your thoughts here.  As I understand it, you've suggested replacing the
> probed instruction with a jump into an instrumentation vma (the XOL
> area, or something similar).  Masami has demonstrated -- through his
> djprobes enhancement to kprobes -- that this can be done for many x86
> instructions.
> 
> What does the code in the jumped-to vma do?  Is the instrumentation code
> that corresponds to the uprobe handlers encoded in an ad hoc .so?


Once the instrumentation is requested by a process that is not the
instrumented one, this looks impossible to set a uprobe without a
minimal voluntary collaboration from the instrumented process
(events sent through IPC or whatever). So that looks too limited,
this is not anymore a true dynamic uprobe.

