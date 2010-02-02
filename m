Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab0BBS2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 13:28:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506Ab0BBS2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 13:28:03 -0500
Date: Tue, 2 Feb 2010 13:27:46 -0500
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: mingo@elte.hu, peterz@infradead.org, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [RFC][x86] move notify_die from nmi.c to traps.c
Message-ID: <20100202182746.GF3062@redhat.com>
References: <1264622622-5778-1-git-send-email-dzickus@redhat.com>
 <1264622622-5778-2-git-send-email-dzickus@redhat.com>
 <20100128151025.GA5338@lenovo>
 <20100128154646.GW4472@redhat.com>
 <20100202175911.GD5436@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202175911.GD5436@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > +	        if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
> > > > +	        			                == NOTIFY_STOP)
> > > > +	                return;
> > > > +
> > > >  #ifdef CONFIG_X86_LOCAL_APIC
> > > >  		/*
> > > >  		 * Ok, so this is none of the documented NMI sources,
> > > > --
> > > 
> > > Hi Don, I suppose this notify_die should be in CONFIG_X86_LOCAL_APIC
> > > section?
> > 
> > To maintain old behaviour I suppose, yes.  Personally I don't think
> > notify_die has anything to do with CONFIG_X86_LOCAL_APIC so I put it in
> > above the #define.
> > 
> 
> I think it is. It becomes that if some (possible buggy in future) code
> notify default_do_nmi via NOTIFY_STOP we may loose unknown_nmi_error

How is that different if the code is under the #define?

> for non-apic configs. And I reckon that even DIE_NMI_IPI is a bit "weird"
> by not being under apic here, but this one should stay there in a
> sake of kgdb I guess.

So you are saying the only way to get NMIs on x86 is through the local
apic?  That seems odd.

I really don't care either way, I was just trying to cleanup the code to
make it easier to understand.  Putting it under the #define didn't seem to
make sense (though that doesn't mean there is a valid reason).

Cheers,
Don
