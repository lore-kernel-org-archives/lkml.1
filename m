Return-Path: <linux-kernel-owner+w=401wt.eu-S1759826AbXH0RXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759826AbXH0RXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 13:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757320AbXH0RXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 13:23:46 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60985 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757247AbXH0RXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 13:23:45 -0400
Subject: Re: [PATCH 1/3] Implement emulator_write_phys()
From: Anthony Liguori <aliguori@us.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <46D2F1B7.70604@qumranet.com>
References: <11882278064002-git-send-email-aliguori@us.ibm.com>
	 <1188227808405-git-send-email-aliguori@us.ibm.com>
	 <46D2F1B7.70604@qumranet.com>
Content-Type: text/plain
Organization: IBM
Date: Mon, 27 Aug 2007 12:23:39 -0500
Message-Id: <1188235419.6364.2.camel@squirrel>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-08-27 at 18:45 +0300, Avi Kivity wrote:
> Anthony Liguori wrote:
> > Since a hypercall may span two pages and is a gva, we need a function to write
> > to a gva that may span multiple pages.  emulator_write_phys() seems like the
> > logical choice for this.
> >
> > @@ -962,8 +962,35 @@ static int emulator_write_std(unsigned long addr,
> >  			      unsigned int bytes,
> >  			      struct kvm_vcpu *vcpu
> 
> I think that emulator_write_emulated(), except for being awkwardly 
> named, should do the job.  We have enough APIs.
> 
> But!  We may not overwrite the hypercall instruction while a vcpu may be 
> executing, since there's no atomicity guarantee for code fetch.  We have 
> to to be out of guest mode while writing that insn.


Hrm, good catch.

How can we get out of guest mode given SMP guest support?

Regards,

Anthony Liguori

> 
> 

