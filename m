Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbYLaOyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbYLaOyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 09:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbYLaOyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 09:54:13 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:48756 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752251AbYLaOyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 09:54:13 -0500
Subject: Re: [PATCH 2/2] Add /proc controls for pdflush threads
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081231000148.6a2f8e3f.akpm@linux-foundation.org>
References: <20081230231152.10427.50620.stgit@hermosa.site>
	 <20081230231233.10427.11443.stgit@hermosa.site>
	 <20081231000148.6a2f8e3f.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Wed, 31 Dec 2008 07:54:06 -0700
Message-Id: <1230735246.3470.107.camel@hermosa.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-31 at 00:01 -0800, Andrew Morton wrote:
> On Tue, 30 Dec 2008 16:12:33 -0700 Peter W Morreale <pmorreale@novell.com> wrote:
> 
> > From: \"Peter W. Morreale\" <pmorreale@novell.com>
> > 
> > This patch adds /proc entries to give the admin the ability to
> > control the minimum and maximum number of pdflush threads.  This allows
> > finer control of pdflush on both large and small machines.
> > 
> > The patch adds '/proc/sys/vm/nr_pdflush_threads_min' and
> > '/proc/sys/vm/nr_pdflush_threads_max' with r/w permissions.
> 
> Why is this needed?  Where's the benefit?  What observations led you to
> develop this patch?  etc.

I assume you are caught up on this thread Andrew?  (A later post
outlined the rational) 

> 
> > --- a/include/linux/sysctl.h
> > +++ b/include/linux/sysctl.h
> > @@ -205,6 +205,8 @@ enum
> >  	VM_PANIC_ON_OOM=33,	/* panic at out-of-memory */
> >  	VM_VDSO_ENABLED=34,	/* map VDSO into new processes? */
> >  	VM_MIN_SLAB=35,		 /* Percent pages ignored by zone reclaim */
> > +	VM_NR_PDFLUSH_THREADS_MAX=36, /* nr_pdflush_threads_max */
> > +	VM_NR_PDFLUSH_THREADS_MIN=37, /* nr_pdflush_threads_min */
> >  };
> 
> We don't do this any more...
> 

nod.  

> >  		.proc_handler	= &proc_dointvec,
> >  	},
> >  	{
> > +		.ctl_name	= VM_NR_PDFLUSH_THREADS_MIN,
> 
> please just use CTL_UNNUMBERED here.
> 

nod.  Thanks,

-PWM

> 

