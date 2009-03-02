Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbZCBQ1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbZCBQ1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 11:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbZCBQ1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:27:43 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:34442 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbZCBQ1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:27:42 -0500
Subject: Re: [RFC][PATCH 8/8] check files for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       hch@infradead.org, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20090302095917.6cfeda55@thinkcentre.lan>
References: <20090227203425.F3B51176@kernel>
	 <20090227203435.98735E54@kernel> <20090302133754.GA8033@us.ibm.com>
	 <20090302095917.6cfeda55@thinkcentre.lan>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 08:27:31 -0800
Message-Id: <1236011251.26788.450.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 09:59 -0600, Nathan Lynch wrote:
> On Mon, 2 Mar 2009 07:37:54 -0600
> "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> > So on a practical note, Ingo's scheme appears to be paying off.  In
> > order for any program's files_struct to be checkpointable right now,
> > it must be statically compiled, else ld.so (I assume) looks up
> > /proc/$$/status.  So since proc is not checkpointable, the result
> > is irreversibly non-checkpointable.
> > 
> > So...  does it make sense to mark proc as checkpointable?  Do we
> > reasonably assume that the same procfile will be available at
> > restart?
> 
> With respect to /proc/$x/* where $x is the pid the restarted task wants,
> is that not a chicken-and-egg problem?

Do you mean that we have to go look into /proc to figure out which task
we want before we can checkpoint it?  That makes the process *doing* the
checkpoint uncheckpointable, but no the process being examined.

Anyway, I'll fix /proc.  It is pretty important.

-- Dave

