Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbYEWUIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbYEWUIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 16:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYEWUIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 16:08:44 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48275 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750750AbYEWUIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 16:08:43 -0400
Date: Fri, 23 May 2008 15:08:42 -0500
From: Robin Holt <holt@sgi.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] use of /sys versus /proc
Message-ID: <20080523200842.GI4287@sgi.com>
References: <20080523131255.C19831F0380@attica.americas.sgi.com> <20080523204739.GA15760@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080523204739.GA15760@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 12:47:39AM +0400, Alexey Dobriyan wrote:
> On Fri, May 23, 2008 at 08:12:55AM -0500, Cliff Wickman wrote:
> > I have a need to display TLB shootdown statistics.  (I'm working
> > on a patch to implement this on a new machine at SGI.)
> > 
> > I had planned to display these statistics through /proc
> > as in arch/ia64/sn/kernel/sn2/sn2_smp.c (/proc/sgi_sn/ptc_statistics).
> > 
> > However, considering the general move to reserve /proc for
> > process-related things, I thought the community might prefer the
> > interface to be in /sys.
> > 
> > But sysfs has an output buffer restriction of one page, which
> > is too restrictive for statistics from very large cpu counts.
> > We intend to display about 10 numbers per cpu.
> > 
> > Besides, the spirit of /sys according to the sysfs.txt documentation:
> >     "Attributes should be ... preferably with only one value
> >      per file. ... acceptable to express an array of values of the same type."
> >   [it also  warns:
> >     "... expressing multiple lines of data, ... is heavily frowned upon.
> >      Doing these things may get you publically humiliated and your code
> >      rewritten without notice."]
> > 
> > If I break up the statistics files per-cpu, or maybe ranges of
> > cpu's, it would create a potentially large number of files in /sys.
> > 
> > Or, I could stick with a single file in /proc.
> > 
> > What would you recommend?
> 
> TLB shootdowns are in /proc/interrupts at least on x86_64.

This is a different engine for our UV platform.  Due to the large number
of nodes with many cpus that may need to be invalidated, we have a
special piece of hardware that assists in broadcasts.  Cliff's upcoming
patch will introduce that.  He has written the driver with some built-in
statistics about the use of that hardware.

Thanks,
Robin
