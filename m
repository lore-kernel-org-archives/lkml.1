Return-Path: <linux-kernel-owner+w=401wt.eu-S935128AbXKPV5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935128AbXKPV5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbXKPV5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:57:12 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:53836 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbXKPV5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:57:11 -0500
Date: Fri, 16 Nov 2007 13:56:42 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: William Cohen <wcohen@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Philip Mucci <mucci@cs.utk.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: perfmon2 merge news
Message-ID: <20071116215642.GF11961@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071113185924.GA22748@suse.de> <20071113120728.4342e7d7.akpm@linux-foundation.org> <20071113203645.GA17145@one.firstfloor.org> <9FF72994-F55A-4B36-9EAA-CB1D2360A6F5@cs.utk.edu> <20071114015210.GA20365@one.firstfloor.org> <A42C2398-2EAB-460C-95C7-686A34A76F82@cs.utk.edu> <p737ikicjbn.fsf@bingen.suse.de> <20071116160056.GF10616@frankl.hpl.hp.com> <20071116162813.GA29644@one.firstfloor.org> <473DCFA3.3020203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473DCFA3.3020203@redhat.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

On Fri, Nov 16, 2007 at 12:13:07PM -0500, William Cohen wrote:
> Andi Kleen wrote:
> >On Fri, Nov 16, 2007 at 08:00:56AM -0800, Stephane Eranian wrote:
> >>No, he is talking about something similar to what was in perfctr.
> >>The kernel emulates 64-bit counters in software and that is you
> >>get back when you read the counters. If you read via RDPMC, you
> >>get 40 bits. To reconstruct the full 64-bit value from user land
> >>you need the upper bits. One approach is for the kernel to allow
> >>you to remap a page that has the 64-bit (software) counters. With
> >>that and a bit of mask/shifting you can reconstruct the full value.
> >
> >You mean the page contains the upper [40;63] bits? 
> >
> >Sounds reasonable, although I don't remember seeing that when I looked
> >at the perfmon code last.
> 
> Upper 32-bit ([32:63]). On many implementations the only lower 32-bit are 
> available in the register. the 32:40 bits in several processor 
> implementation of x86 processors can not be set to bit outside of sign 
> extension of bit 32. On other processor implementations the event counters 
> are only 32-bit in width.
> 
That is quite true on Intel's. Perfmon2 only considers the bottom 31 bits as
true counter bits, the rest is forced to 1. This is true even on Intel Core 2.

--
-Stephane
