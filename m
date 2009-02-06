Return-Path: <linux-kernel-owner+w=401wt.eu-S1758651AbZBFQ3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbZBFQ3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbZBFQ3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:29:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45813 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbZBFQ3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:29:31 -0500
Date: Fri, 6 Feb 2009 11:28:43 -0500
From: Jason Baron <jbaron@redhat.com>
To: Greg Banks <gnb@melbourne.sgi.com>, greg@kroah.com
Cc: linux-kernel@vger.kernel.org, nfsv4@linux-nfs.org,
       systemtap@sources.redhat.com
Subject: Re: [Patch 0/2] dynamic debug
Message-ID: <20090206162843.GA3397@redhat.com>
References: <20090205164520.GB3114@redhat.com> <20090205175849.GA936@kroah.com> <20090205184304.GF3114@redhat.com> <498B9852.5060909@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B9852.5060909@melbourne.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 12:54:26PM +1100, Greg Banks wrote:
> > ok, patch below resolves the space issue.
> >   
> 
> The above patch makes the output much easier for a human to read, which
> is good.
> 
> However it's half the job.  The parser for the language used when
> writing to the control file still uses whitespace to tokenize and is
> still too dumb to handle quoting and so needs all whitespace escaped,
> like this
> 
> #echo -n 'format Setting\040node\040for\040non-present\040cpu +p' > /mnt/debugfs/dynamic_debug/control
> 
> Which is documented in the howto.  So that you could copy-n-paste in a
> terminal window, I chose to make the input and output formats as similar
> as possible, and used escaping for all whitespace on output.  That was
> just me being lazy, sorry.  Below is a patch which implements a better
> solution, which is to fix ddebug_tokenize() to handle simple quoting so
> the above would look like
> 
> #echo -n 'format "Setting node for non-present cpu" +p' > /mnt/debugfs/dynamic_debug/control
> 
> 

agreed. patch looks good...and I've tested it.

Greg KH, to be clear, Greg Banks patch applies on top of the additional
patch which I sent.

thanks,

-Jason
