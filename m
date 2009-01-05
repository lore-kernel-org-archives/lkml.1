Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbZAEXhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbZAEXhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 18:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZAEXhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 18:37:46 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:42547 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751287AbZAEXhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 18:37:45 -0500
Subject: Re: + mm-add-proc-controls-for-pdflush-threads.patch added to -mm
	tree
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com
In-Reply-To: <20090105232119.GA3860@x200.localdomain>
References: <200901052253.n05Mr3au014416@imap1.linux-foundation.org>
	 <20090105232119.GA3860@x200.localdomain>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Mon, 05 Jan 2009 23:37:38 +0000
Message-Id: <1231198658.3470.357.camel@hermosa.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 02:21 +0300, Alexey Dobriyan wrote:
> On Mon, Jan 05, 2009 at 02:53:03PM -0800, akpm@linux-foundation.org wrote:
> > Subject: mm: add /proc controls for pdflush threads
> 
> > @@ -1022,6 +1023,28 @@ static struct ctl_table vm_table[] = {
> >  		.proc_handler	= &proc_dointvec,
> >  	},
> >  	{
> > +		.ctl_name	= CTL_UNNUMBERED,
> > +		.procname	= "nr_pdflush_threads_min",
> > +		.data		= &nr_pdflush_threads_min,
> > +		.maxlen		= sizeof nr_pdflush_threads_min,
> > +		.mode		= 0644 /* read-write */,
> > +		.proc_handler	= &proc_dointvec_minmax,
> > +		.strategy	= &sysctl_intvec,
> 
> .strategy isn't needed for /proc-only sysctls.
> 

It is for checking the bounds of the new setting.  Without it would be
possible to set the max thread count higher than the minimum and vice
versa.  What you would actually wind up with would depend upon the
number of outstanding threads at the time of the sysctl change. 

The specific limitations are that you cannot set max < min and min >
max.  In addition, since the only way to get another pdflush thread is
via a pdflush thread, the minimum 'min' is 1.  And the 'max' is an
arbitrary 1000. 

Best,
-PWM



> > +		.extra1		= &one,
> > +		.extra2		= &nr_pdflush_threads_max,
> > +	},
> > +	{
> > +		.ctl_name	= CTL_UNNUMBERED,
> > +		.procname	= "nr_pdflush_threads_max",
> > +		.data		= &nr_pdflush_threads_max,
> > +		.maxlen		= sizeof nr_pdflush_threads_max,
> > +		.mode		= 0644 /* read-write */,
> > +		.proc_handler	= &proc_dointvec_minmax,
> > +		.strategy	= &sysctl_intvec,
> 
> .strategy isn't needed for /proc-only sysctls.

