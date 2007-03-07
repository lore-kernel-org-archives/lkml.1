Return-Path: <linux-kernel-owner+w=401wt.eu-S1030532AbXCGWZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030532AbXCGWZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965707AbXCGWZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:25:45 -0500
Received: from www.osadl.org ([213.239.205.134]:52322 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965700AbXCGWZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:25:43 -0500
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Zachary Amsden <zach@vmware.com>
Cc: Dan Hecht <dhecht@vmware.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <45EF39F3.8050506@vmware.com>
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>
	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>
	 <20070306084647.GA16280@elte.hu>  <45ED2C82.3080008@vmware.com>
	 <1173178774.24738.311.camel@localhost.localdomain>
	 <45EDD82F.90204@vmware.com>
	 <1173225182.24738.507.camel@localhost.localdomain>
	 <45EE0628.1080108@goop.org>  <45EE08E8.2020008@vmware.com>
	 <1173228544.24738.514.camel@localhost.localdomain>
	 <45EE0D10.7070807@vmware.com>
	 <1173230305.24738.529.camel@localhost.localdomain>
	 <45EE1EA3.90803@vmware.com>
	 <1173256666.24738.576.camel@localhost.localdomain>
	 <45EEF966.6060902@goop.org>
	 <1173300032.24738.750.camel@localhost.localdomain>
	 <45EF2991.1020204@goop.org>
	 <1173303639.24738.814.camel@localhost.localdomain>
	 <45EF2FFE.7010705@vmware.com>
	 <1173305670.24738.849.camel@localhost.localdomain>
	 <45EF39F3.8050506@vmware.com>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 23:31:53 +0100
Message-Id: <1173306713.24738.861.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 14:17 -0800, Zachary Amsden wrote:
> Thomas Gleixner wrote:
> > Simply because you _ABUSE_ timer_init_hook() to set it up. Keep it self
> > contained and do not impose restrictions on the kernel core code, which
> > we have to maintain.
> >   
> 
> But time_init_hook is supposed to be abused.  That is its purpose - to 
> be a hook for different time devices on SGI Visual Workstation and 
> Voyager.  And we don't actually abuse it anymore, we just bypass it 
> because the default timer init path wants to setup the PIT or the HPET, 
> neither of which should be used in paravirt.

It is there for those hardware platforms, but using it inside your clock
event device is _JUST_ wrong.

Please make these things self contained and not relying on whatever
time_init_hook() contains.

	tglx


