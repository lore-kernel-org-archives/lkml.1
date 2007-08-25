Return-Path: <linux-kernel-owner+w=401wt.eu-S932847AbXHYAsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847AbXHYAsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 20:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765964AbXHYAsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 20:48:03 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44027 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765812AbXHYAsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 20:48:01 -0400
Date: Fri, 24 Aug 2007 17:46:40 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: kernel BUG with 2.6.23-rc3-mm1: skb_over_panic
Message-ID: <20070825004640.GA21756@kroah.com>
References: <20070824224707.GA7275@Krystal> <20070824161029.6236a5f4.akpm@linux-foundation.org> <20070825001638.GB9811@Krystal> <20070824174450.70337f4f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824174450.70337f4f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 05:44:50PM -0700, Andrew Morton wrote:
> On Fri, 24 Aug 2007 20:16:38 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Andrew Morton (akpm@linux-foundation.org) wrote:
> > > On Fri, 24 Aug 2007 18:47:07 -0400
> > > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > 
> > > > Hi Andrew,
> > > > 
> > > > I get the following BUG when booting 2.6.23-rc3-mm1 on i386. I wonder if
> > > > you would have some ideas about what is causing this problem. I'll start
> > > > bissecting it soon. I seems to be caused by an buggy skb_put call in
> > > > kobject_uevent_env.
> > > > 
> > > > Thanks,
> > > > 
> > > > Mathieu
> > > > 
> > > > 
> > > 
> > > hm, don't know, sorry.  Kay fixed a few things in there, but iirc pretty
> > > much all of the fixes were in rc3-mm1 anyway.
> > > 
> > > I doubt if bisection will tell us a lot: it'll probably point at
> > > gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch.
> > > 
> > > What we _would_ like to know is which sysfs file is being written to.  We
> > > used to have a debug patch to exactly address this problem but it got
> > > transferred into Greg's tree from whence it mysteriously disappeared.
> > > 
> > 
> > Ok, here it is:
> > 
> > filename :
> > 
> > /devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/rev
> 
> Bah.  I've never found a sane way of going from a sysfs pathname back to the
> code which implements that pathname :(
> 
> <greps the tree for '"rev"'>
> 
> <comes up with zilch>

It's a scsi file, as the above is a scsi device.  It's created in the
drivers/scsi/scsi_sysfs.c file.

Kay, did you miss this set of attributes somehow?

thanks,

greg k-h
