Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbZECShI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbZECShI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 14:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbZECSgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 14:36:55 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:64505 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbZECSgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 14:36:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T9D9pc2+rP9OS+n6tdKDDrsl5LqQkBxnrHUuwbnHqEYNn0oNY4N9y1fx6ZsXPLjQs0
         vYSNwtAMdsnjkpxaY/2eXbEl+6svMeIwGO6w6hIEHzbSQdUrWTMYVfKiBSncrA5PS3zB
         5kHPdXAc1KmbhUzTU1DvO6HwcVk6a2tJEOejw=
Date: Sun, 3 May 2009 20:36:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Josh Stone <jistone@redhat.com>, Jason Baron <jbaron@redhat.com>,
       mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] export softirq_to_name symbol
Message-ID: <20090503183650.GB6010@nowhere>
References: <20090501193022.GB3111@redhat.com> <20090501195015.GA31694@infradead.org> <49FB5686.8020908@redhat.com> <20090501201028.GA2084@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501201028.GA2084@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 04:10:28PM -0400, Christoph Hellwig wrote:
> On Fri, May 01, 2009 at 01:07:34PM -0700, Josh Stone wrote:
> > I'm adding SystemTap support for the format strings in the TRACE_EVENT
> > macros.  The softirq's TP_fast_assign uses softirq_to_name, and so that
> > array is needed to prepare the softirq's trace string.
> > 
> > So, there's no explicit reference to the symbol in SystemTap -- it's
> > just indirectly referenced by the tracepoint declaration.
> 
> TP_fast_assign should only be called by core code, it's the piece that
> copies the trace into the ring buffer.  If systemtap copies events into
> the ring buffer from modular code something is deeply wrong in it's
> design.


In itself, the use of TRACE_EVENT from a module is fine, otherwise
Steve wouldn't have written the module support.

For example the mac80211 subsystem can be built as a module, and
if a tracing code is merged for this subsystem, we want it to be
usable whenever it is build as a module or not.

Frederic.

