Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbZCBRXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbZCBRXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 12:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZCBRXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 12:23:03 -0500
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:32832 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbZCBRXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 12:23:01 -0500
Date: Mon, 2 Mar 2009 11:22:47 -0600
From: Nathan Lynch <ntl@pobox.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       hch@infradead.org, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC][PATCH 8/8] check files for checkpointability
Message-ID: <20090302112247.76bb3662@thinkcentre.lan>
In-Reply-To: <1236011251.26788.450.camel@nimitz>
References: <20090227203425.F3B51176@kernel> <20090227203435.98735E54@kernel>
 <20090302133754.GA8033@us.ibm.com> <20090302095917.6cfeda55@thinkcentre.lan>
 <1236011251.26788.450.camel@nimitz>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: C5F8D89C-074E-11DE-8724-CFA5EBB1AA3C-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Mar 2009 08:27:31 -0800
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On Mon, 2009-03-02 at 09:59 -0600, Nathan Lynch wrote:
> > On Mon, 2 Mar 2009 07:37:54 -0600
> > "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> > > So on a practical note, Ingo's scheme appears to be paying off.
> > > In order for any program's files_struct to be checkpointable
> > > right now, it must be statically compiled, else ld.so (I assume)
> > > looks up /proc/$$/status.  So since proc is not checkpointable,
> > > the result is irreversibly non-checkpointable.
> > > 
> > > So...  does it make sense to mark proc as checkpointable?  Do we
> > > reasonably assume that the same procfile will be available at
> > > restart?
> > 
> > With respect to /proc/$x/* where $x is the pid the restarted task
> > wants, is that not a chicken-and-egg problem?
> 
> Do you mean that we have to go look into /proc to figure out which
> task we want before we can checkpoint it?  That makes the process
> *doing* the checkpoint uncheckpointable, but no the process being
> examined.

No.. I mean what if a process 1234 does

f = fopen("/proc/1234/stat", "r");

and is then checkpointed.  Can that path be resolved during restart,
before pid 1234 is alive?
