Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbXEaEmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbXEaEmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757618AbXEaEmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:42:15 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:50669 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757504AbXEaEmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:42:15 -0400
Date: Thu, 31 May 2007 06:43:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, David Chinner <dgc@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Subject: Re: BUG: sleeping function called from invalid context at kernel/fork.c:385
Message-ID: <20070531044314.GA20795@uranus.ravnborg.org>
References: <617E1C2C70743745A92448908E030B2A01929C15@scsmsx411.amr.corp.intel.com> <Pine.LNX.4.64.0705301630360.3568@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705301630360.3568@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 04:31:35PM -0700, Christoph Lameter wrote:
> On Wed, 30 May 2007, Luck, Tony wrote:
> 
> > 
> > > `.exit.text' referenced in section `.init.text' of drivers/built-in.o: 
> > > defined in discarded section `.exit.text' of drivers/built-in.o
> > 
> > 
> > This one is a fatal error ... the code is trying to call a function
> > that has been marked __exit in a driver that has been built-in, instead
> > of as a module.  Since a builtin driver can never be unloaded, the kernel
> > has thrown away all the __exit routines (at link time).
> > 
> > The error message appears less than helpful in tracking down which
> > routine in which driver is the problem though.
> 
> Right. I have no idea where to look. The function has no name? Or is the 
> segment .exit.text referenced by namne in .init.text?
Unfortunately modpost does not alows know how to resolve symbol names
from addresses. Lately it has been improves by adding support for 
addends in ELF. But that is beyond my ELF knowledge atm so
I cannot improve it.

What you can do (apart from the cscope trick as Randy suggest) is
to run modpost manual on all .o files in drivers/

If the cross reference happens in a single .o file you will get
a hit there.
And if it is say in scsi then you will get a hit in scsi/built-in.o

Hope this helps.

	Sam
