Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbXH2Fxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbXH2Fxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 01:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbXH2Fx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 01:53:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:53734 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbXH2FxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 01:53:25 -0400
Subject: Re: [kvm-devel] [PATCH 3/3] KVM paravirt-ops implementation
From: Anthony Liguori <anthony@codemonkey.ws>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org
In-Reply-To: <1188325890.5531.78.camel@localhost.localdomain>
References: <11882278064002-git-send-email-aliguori@us.ibm.com>
	 <1188227808405-git-send-email-aliguori@us.ibm.com>
	 <11882278082826-git-send-email-aliguori@us.ibm.com>
	 <11882278093751-git-send-email-aliguori@us.ibm.com>
	 <1188325890.5531.78.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 29 Aug 2007 00:53:15 -0500
Message-Id: <1188366795.6337.11.camel@squirrel>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-29 at 04:31 +1000, Rusty Russell wrote:
> On Mon, 2007-08-27 at 10:16 -0500, Anthony Liguori wrote:
> > @@ -569,6 +570,7 @@ asmlinkage void __init start_kernel(void)
> >  	}
> >  	sort_main_extable();
> >  	trap_init();
> > +	kvm_guest_init();
> >  	rcu_init();
> >  	init_IRQ();
> >  	pidhash_init();
> 
> Hi Anthony,
> 
> 	This placement seems arbitrary.  Why not earlier from setup_arch, or as
> a normal initcall?

The placement is important if we wish to have a paravirt_ops hook for
the interrupt controller.  This is the latest possible spot we can do
it.  A comment is probably appropriate here.

Regards,

Anthony Liguori

> Rusty.
> 
> 
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browser.
> Download your FREE copy of Splunk now >>  http://get.splunk.com/
> _______________________________________________
> kvm-devel mailing list
> kvm-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/kvm-devel

