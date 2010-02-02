Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab0BBR7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 12:59:22 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:45434 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab0BBR7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 12:59:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Fopqm1/F/QQfhj26RYL1AgJdZIO4entJf9+j/ASbuwKW+FxSz8rKYdC33Is/EDFiw2
         qZy5kSTirLAXssBE8kzxuTAXPTLlAekWyjWHSwB4Z7MPKWdJgnDcOKgaLn25j1NeYI1Y
         PO11fgjZQxaZ02dXu7GVqpo1+gZY895zE1VKY=
Date: Tue, 2 Feb 2010 20:59:11 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [RFC][x86] move notify_die from nmi.c to traps.c
Message-ID: <20100202175911.GD5436@lenovo>
References: <1264622622-5778-1-git-send-email-dzickus@redhat.com> <1264622622-5778-2-git-send-email-dzickus@redhat.com> <20100128151025.GA5338@lenovo> <20100128154646.GW4472@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100128154646.GW4472@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 10:46:46AM -0500, Don Zickus wrote:
> On Thu, Jan 28, 2010 at 06:10:25PM +0300, Cyrill Gorcunov wrote:
> > On Wed, Jan 27, 2010 at 03:03:40PM -0500, Don Zickus wrote:
> > ...
> > > diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> > > index 3339917..3b98dd3 100644
> > > --- a/arch/x86/kernel/traps.c
> > > +++ b/arch/x86/kernel/traps.c
> > > @@ -400,6 +400,11 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
> > >  		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
> > >  								== NOTIFY_STOP)
> > >  			return;
> > > +
> > > +	        if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
> > > +	        			                == NOTIFY_STOP)
> > > +	                return;
> > > +
> > >  #ifdef CONFIG_X86_LOCAL_APIC
> > >  		/*
> > >  		 * Ok, so this is none of the documented NMI sources,
> > > --
> > 
> > Hi Don, I suppose this notify_die should be in CONFIG_X86_LOCAL_APIC
> > section?
> 
> To maintain old behaviour I suppose, yes.  Personally I don't think
> notify_die has anything to do with CONFIG_X86_LOCAL_APIC so I put it in
> above the #define.
> 

I think it is. It becomes that if some (possible buggy in future) code
notify default_do_nmi via NOTIFY_STOP we may loose unknown_nmi_error
for non-apic configs. And I reckon that even DIE_NMI_IPI is a bit "weird"
by not being under apic here, but this one should stay there in a
sake of kgdb I guess.

All-in-one: I would better not change old behaviour.

Though, it is possbile that I just miss something obvious :)

> Cheers,
> Don
> 
	-- Cyrill
