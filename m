Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974Ab0A1PrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab0A1PrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 10:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964Ab0A1PrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 10:47:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639Ab0A1PrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 10:47:20 -0500
Date: Thu, 28 Jan 2010 10:46:46 -0500
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: mingo@elte.hu, peterz@infradead.org, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [RFC][x86] move notify_die from nmi.c to traps.c
Message-ID: <20100128154646.GW4472@redhat.com>
References: <1264622622-5778-1-git-send-email-dzickus@redhat.com>
 <1264622622-5778-2-git-send-email-dzickus@redhat.com>
 <20100128151025.GA5338@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100128151025.GA5338@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 06:10:25PM +0300, Cyrill Gorcunov wrote:
> On Wed, Jan 27, 2010 at 03:03:40PM -0500, Don Zickus wrote:
> ...
> > diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> > index 3339917..3b98dd3 100644
> > --- a/arch/x86/kernel/traps.c
> > +++ b/arch/x86/kernel/traps.c
> > @@ -400,6 +400,11 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
> >  		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
> >  								== NOTIFY_STOP)
> >  			return;
> > +
> > +	        if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
> > +	        			                == NOTIFY_STOP)
> > +	                return;
> > +
> >  #ifdef CONFIG_X86_LOCAL_APIC
> >  		/*
> >  		 * Ok, so this is none of the documented NMI sources,
> > --
> 
> Hi Don, I suppose this notify_die should be in CONFIG_X86_LOCAL_APIC
> section?

To maintain old behaviour I suppose, yes.  Personally I don't think
notify_die has anything to do with CONFIG_X86_LOCAL_APIC so I put it in
above the #define.

Cheers,
Don
