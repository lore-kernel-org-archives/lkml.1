Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbYCMGZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbYCMGZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 02:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbYCMGZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 02:25:00 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:16743 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbYCMGY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 02:24:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LEEw6vKW/hJUmcxW0vXmI81nTX0tbrUQRoayfc7OLjsBJP3EtrNyk+ZOZvAwy/Bn/pgMWCRyG9PRLmE70Nau7NBvAnNfRBHOWHxfvutTvZZFd/LOMtI8qK96ofupZlVrJ9KKx1qQ6jl9WbOe5gml2pnLoKGeuSrmCrTW53rCFjg=
Message-ID: <86802c440803122324w1de8dee2ud35c20c7a696b6b4@mail.gmail.com>
Date: Wed, 12 Mar 2008 23:24:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: pcibios_scanned needs to be set in ACPI? (was Re: 2.6.25-rc5: Reported regressions from 2.6.24)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Jeff Garzik" <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>, "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Len Brown" <len.brown@intel.com>,
       "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <20080313054400.GA17102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org>
	 <200803112341.42517.rjw@sisk.pl>
	 <alpine.LFD.1.00.0803121300160.3557@woody.linux-foundation.org>
	 <20080312203205.GB17187@kroah.com> <20080312212704.GA16836@kroah.com>
	 <20080312213826.GA17101@kroah.com>
	 <alpine.LFD.1.00.0803121521550.3557@woody.linux-foundation.org>
	 <20080312225421.GA24449@kroah.com>
	 <alpine.LFD.1.00.0803121604580.3557@woody.linux-foundation.org>
	 <20080313054400.GA17102@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 10:44 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Mar 12, 2008 at 04:09:17PM -0700, Linus Torvalds wrote:
>  >
>  >
>
> > On Wed, 12 Mar 2008, Greg KH wrote:
>  > >
>  > > I can't get a box here to produce both of those PCI: messages myself,
>  > > and neither can Len, so something is really odd here.
>
>  Ok, stupid me, this was my fault.  I was assuming that pci busses would
>  never be registered multiple times with the pci core.  Obviously this
>  isn't true.  The previous patch I proposed was only paying attention to
>  the PCI devices, and that logic is just fine (it's already protected
>  when it is attempted to be registered multiple times.)
>
>  So, the patch below fixes the issue for me, and reboot seems to work as
>  well.
>
>  Guennadi, can you test this out on your machine?
>
>  thanks for your patience,
>
>  greg k-h
>
>
>  From: Greg Kroah-Hartman <gregkh@suse.de>
>  Subject: PCI: fix issue with busses registering multiple times in sysfs
>
>  PCI busses can be registered multiple times, so we need to detect if we
>  have registered our bus structure in sysfs already.  If so, don't do it
>  again.
>
>  Thanks to Guennadi Liakhovetski <g.liakhovetski@gmx.de> for reporting
>  the problem, and to Linus for poking me to get me to believe that it was
>  a real problem.
>
>  Cc: Linus Torvalds <torvalds@linux-foundation.org>
>  Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

wonder if

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commitdiff;h=fff07473e243989a2739b9d802d63e051ade7188

helps.

YH
