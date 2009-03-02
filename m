Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbZCBSf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbZCBSf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbZCBSfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:35:48 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:38726 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbZCBSfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:35:48 -0500
Date: Mon, 2 Mar 2009 12:35:22 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       hch@infradead.org, Nathan Lynch <ntl@pobox.com>,
       Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC][PATCH 8/8] check files for checkpointability
Message-ID: <20090302183522.GA13447@us.ibm.com>
References: <20090227203425.F3B51176@kernel> <20090227203435.98735E54@kernel> <20090302133754.GA8033@us.ibm.com> <20090302095917.6cfeda55@thinkcentre.lan> <1236011251.26788.450.camel@nimitz> <20090302112247.76bb3662@thinkcentre.lan> <1236015052.26788.471.camel@nimitz> <20090302174433.GA12708@us.ibm.com> <1236017600.26788.488.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236017600.26788.488.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> On Mon, 2009-03-02 at 11:44 -0600, Serge E. Hallyn wrote:
> > Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> > > On Mon, 2009-03-02 at 11:22 -0600, Nathan Lynch wrote:
> > > > No.. I mean what if a process 1234 does
> > > > 
> > > > f = fopen("/proc/1234/stat", "r");
> > > > 
> > > > and is then checkpointed.  Can that path be resolved during restart,
> > > > before pid 1234 is alive?
> > > 
> > > Heh, that's a good one.
> > > 
> > > It does mean that we can't do restore like this:
> > > 
> > > 	for_each_cr_task()
> > > 		restore_task_struct()
> > > 		restore_files()
> > > 		...
> > > 
> > > We have to do:
> > > 
> > > 	for_each_cr_task()
> > > 		restore_task_struct()
> > > 	for_each_cr_task()
> > > 		restore_files()
> > >
> > Which is what we actually do, right?
> 
> OK, I have a really evil one.
> 
> What if task 1234 does:
> 
> 	open(O_RDONLY, "/proc/5678/fdinfo/44");
> 
> and task 5678 does:
> 
> 	open(O_RDONLY, "/proc/5678/fdinfo/55");

Nice one.  Let's make fdinfo files uncheckpointable for now :)

-serge
