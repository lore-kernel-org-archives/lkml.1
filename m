Return-Path: <linux-kernel-owner+w=401wt.eu-S1760327AbXLADEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760327AbXLADEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 22:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757273AbXLADEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 22:04:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40961 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151AbXLADEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 22:04:15 -0500
Date: Fri, 30 Nov 2007 19:02:27 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Mark Lord <lkml@rtr.ca>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, abelay@novell.com,
       lenb@kernel.org, mlord@pobox.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
Message-ID: <20071130190227.1976e682@laptopd505.fenrus.org>
In-Reply-To: <4750CC78.9070105@rtr.ca>
References: <200711302153.lAULrZ7n026255@imap1.linux-foundation.org>
	<924EFEDD5F540B4284297C4DC59F3DEE2FAE6A@orsmsx423.amr.corp.intel.com>
	<20071130142058.816d1693.akpm@linux-foundation.org>
	<924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com>
	<4750CC78.9070105@rtr.ca>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007 21:52:40 -0500
Mark Lord <lkml@rtr.ca> wrote:

> Pallipadi, Venkatesh wrote:

> > 
> > Exporting it as read only should be OK. We also need to know if
> > there are hard user space dependency on writing to this from
> > userspace.
> ..
> 
> Well, actually..  my scripts have a firm need to write "1" to it,
> and then later restore the original value.
> 
> This is needed to *greatly* speed up an otherwise sluggish binary I
> use, 

just curious, but this does sound like the c-state code has a bug...
independent of the sysfs thing, I think that really needs solving

Can you describe the behavior a little? Or provide information to the
degree that some of us can figure out how to tweak the algorithm..,.


>as well as whenever I want to semi-accurately benchmark I/O.
> 
> Is there another way to achieve exactly the same behaviour?

in -mm there is.. the QoS stuff allows you to set maximum tolerable
latency. If your app cant take any latency, you should set those... and
the side effect is that the kernel will not do long-latency C-states or
P-state transitions..

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
