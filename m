Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbZCBP7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbZCBP7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 10:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755998AbZCBP7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 10:59:31 -0500
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:63827 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615AbZCBP7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 10:59:30 -0500
Date: Mon, 2 Mar 2009 09:59:17 -0600
From: Nathan Lynch <ntl@pobox.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       hch@infradead.org, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC][PATCH 8/8] check files for checkpointability
Message-ID: <20090302095917.6cfeda55@thinkcentre.lan>
In-Reply-To: <20090302133754.GA8033@us.ibm.com>
References: <20090227203425.F3B51176@kernel> <20090227203435.98735E54@kernel>
 <20090302133754.GA8033@us.ibm.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 1B17C772-0743-11DE-831B-CFA5EBB1AA3C-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 07:37:54 -0600
"Serge E. Hallyn" <serue@us.ibm.com> wrote:

> Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> > 
> > Introduce a files_struct counter to indicate whether a particular
> > file_struct has ever contained a file which can not be
> > checkpointed.  This flag is a one-way trip; once it is set, it may
> > not be unset.
> > 
> > We assume at allocation that a new files_struct is clean and may
> > be checkpointed.  However, as soon as it has had its files filled
> > from its parent's, we check it for real in __scan_files_for_cr().
> > At that point, we mark it if it contained any uncheckpointable
> > files.
> > 
> > We also check each 'struct file' when it is installed in a fd
> > slot.  This way, if anyone open()s or managed to dup() an
> > unsuppored file, we can catch it.
> > 
> > Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> 
> So on a practical note, Ingo's scheme appears to be paying off.  In
> order for any program's files_struct to be checkpointable right now,
> it must be statically compiled, else ld.so (I assume) looks up
> /proc/$$/status.  So since proc is not checkpointable, the result
> is irreversibly non-checkpointable.
> 
> So...  does it make sense to mark proc as checkpointable?  Do we
> reasonably assume that the same procfile will be available at
> restart?

With respect to /proc/$x/* where $x is the pid the restarted task wants,
is that not a chicken-and-egg problem?
