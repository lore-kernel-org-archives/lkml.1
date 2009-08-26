Return-Path: <linux-kernel-owner+w=401wt.eu-S1751150AbZHZOoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150AbZHZOoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbZHZOod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:44:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58099 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZHZOod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:44:33 -0400
Date: Wed, 26 Aug 2009 10:44:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
In-Reply-To: <20090826135331.GF6009@nowhere>
Message-ID: <alpine.DEB.2.00.0908261044071.23885@gandalf.stny.rr.com>
References: <20090825141547.GE6114@nowhere> <20090825160237.GG4639@cetus.boeblingen.de.ibm.com> <20090826123550.GD6009@nowhere> <20090826125943.GA5946@osiris.boeblingen.de.ibm.com> <20090826133019.GE6009@nowhere> <alpine.DEB.2.00.0908260944540.27786@gandalf.stny.rr.com>
 <20090826135331.GF6009@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Aug 2009, Frederic Weisbecker wrote:
> > 
> > All kernel threads have a NULL t->mm. Since do_fork is called by kthreadd 
> > and not by kthread_create, the caller of do_fork will also have a
> > t->mm = NULL.
> > 
> > -- Steve
> > 
> 
> Yeah, that's the case with kthread_create() creation fashion,
> but what if you create a kernel thread using the low level
> kernel_thread() directly (ie: without relaying on kthreadd queue)?
> 
> Especially in Heiko example, it seems to be a duplication of user
> task.
> 
> I wonder what obvious think I'm missing here...

The obvious is that those calls are buggy ;-)

-- Steve

