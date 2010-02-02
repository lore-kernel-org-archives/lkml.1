Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab0BBSoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 13:44:14 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:54681 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab0BBSoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 13:44:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k/NuTJNS5K5zaD2q8xwsnZ/atR3Yts3Kn/lwYkpWdOSX3seoshPsFFyRTgjRfp44o1
         xd+Ff+buvBHDpxB74CTFW2R39LKDdQ/mXg6V8ZXkdape52X3+5lyggw0nUzIJFEhi3+4
         vvZiPpvOE3ZUfxCDJalccRFQipGijti0Cj3HM=
Date: Tue, 2 Feb 2010 21:44:07 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [RFC][x86] move notify_die from nmi.c to traps.c
Message-ID: <20100202184407.GE5436@lenovo>
References: <1264622622-5778-1-git-send-email-dzickus@redhat.com> <1264622622-5778-2-git-send-email-dzickus@redhat.com> <20100128151025.GA5338@lenovo> <20100128154646.GW4472@redhat.com> <20100202175911.GD5436@lenovo> <20100202182746.GF3062@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202182746.GF3062@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 01:27:46PM -0500, Don Zickus wrote:
> > > > > +	        if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
> > > > > +	        			                == NOTIFY_STOP)
> > > > > +	                return;
> > > > > +
> > > > >  #ifdef CONFIG_X86_LOCAL_APIC
> > > > >  		/*
> > > > >  		 * Ok, so this is none of the documented NMI sources,
> > > > > --
> > > > 
> > > > Hi Don, I suppose this notify_die should be in CONFIG_X86_LOCAL_APIC
> > > > section?
> > > 
> > > To maintain old behaviour I suppose, yes.  Personally I don't think
> > > notify_die has anything to do with CONFIG_X86_LOCAL_APIC so I put it in
> > > above the #define.
> > > 
> > 
> > I think it is. It becomes that if some (possible buggy in future) code
> > notify default_do_nmi via NOTIFY_STOP we may loose unknown_nmi_error
> 
> How is that different if the code is under the #define?
> 

It matters if code is compiled without CONFIG_X86_LOCAL_APIC.

> > for non-apic configs. And I reckon that even DIE_NMI_IPI is a bit "weird"
> > by not being under apic here, but this one should stay there in a
> > sake of kgdb I guess.
> 
> So you are saying the only way to get NMIs on x86 is through the local
> apic?  That seems odd.

No, I didn't say that. I said that semantic of DIE_NMI_IPI is somehow
weird for me. There is no IPI if no apic present (at least in official
way). But in a sake of kgdb which checks for this notification we should
save it here.

> 
> I really don't care either way, I was just trying to cleanup the code to
> make it easier to understand.  Putting it under the #define didn't seem to
> make sense (though that doesn't mean there is a valid reason).
> 

Don, please don't get me wrong. At moment I don't see problems with putting
DIE_NMI in a place you had put it at. But something worrying me, can't explain
what exactly, perhaps that is how paranoia happens :)

>
> Cheers,
> Don
> 
	-- Cyrill
