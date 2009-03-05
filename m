Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbZCEMan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbZCEMan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 07:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZCEMae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 07:30:34 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:16244 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbZCEMae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 07:30:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GkTGvIDcME382tXDdykZKuUMzTkxIvSnlMV8fJauvo/Qe4pu8Li8M4h/zRJdnO4anP
         ZPiG9u60uskCnl8hZvlSq7Ptqk83smaG1pgpgcFGtLFaF0KPyxz6Q1thxc6TdrTpcT0I
         0tqvA4IDprkQHC2YNaNqFwfNbmq7ZLSu+xGcA=
Date: Thu, 5 Mar 2009 13:30:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: mingo@elte.hu, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 11/11] ftrace plugin for kernel symbol tracing using HW
	Breakpoint interfaces
Message-ID: <20090305123027.GJ5359@nowhere>
References: <20090305043440.189041194@linux.vnet.ibm.com> <20090305044333.GM17747@in.ibm.com> <20090305063703.GB5359@nowhere> <20090305113359.GA25213@in.ibm.com> <20090305121929.GB25213@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305121929.GB25213@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 05:49:29PM +0530, K.Prasad wrote:
> On Thu, Mar 05, 2009 at 05:03:59PM +0530, K.Prasad wrote:
> > On Thu, Mar 05, 2009 at 07:37:04AM +0100, Frederic Weisbecker wrote:
> > > On Thu, Mar 05, 2009 at 10:13:33AM +0530, prasad@linux.vnet.ibm.com wrote:
> > > > This patch adds an ftrace plugin to detect and profile memory access over
> > > > kernel variables. It uses HW Breakpoint interfaces to 'watch memory
> > > > addresses.
> > > > 
> > > > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com> 
> > > > ---
> > > 
> > > 
> > > > +
> > > > +		ret = process_new_ksym_entry(entry, ksymname, op, ksym_addr);
> > > 
> > > 
> > > You are passing an allocated entry as a parameter, but later on process_new_ksym_entry()
> > > you allocate a new space for entry.
> > > I'm confused.
> > > 
> > >
> > 
> > When changed = 1, entry points to the existing instance of 'struct
> > trace_ksym' and will be used for changing the type of breakpoint. If the
> > input is a new request to ksym_trace_filter file process_new_ksym_entry()
> > takes a pointer to 'struct trace_ksym' i.e entry for
> > allocation/initialisation rather than use it as a parameter in the true
> > sense.
> > 
> > This is similar to the usage of parameters 'ksymname and addr' in
> > parse_ksym_trace_str() where they are used to return multiple values.
> > 
> > I hope you find the usage acceptable.
> >
> 
> aah....but entry isn't used anywhere anywhere in
> ksym_trace_filter_write() after process_new_ksym_entry(). I was trying
> to explain why I used entry as a parameter to let
> process_new_ksym_entry() return multiple values, but it isn't used after
> that. I will remove it, and thanks for pointing it.
> 
> -- K.Prasad
> 

Ah, I thought I misunderstood something :-)

Thanks.

