Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbZGGHlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbZGGHlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 03:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbZGGHlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 03:41:00 -0400
Received: from ey-out-1920.google.com ([74.125.78.145]:5584 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbZGGHlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 03:41:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bSAkOJQ7mgqAmcEv+/n6Rrz7yH8GsjSQn+jTTXkZR+RhsRWH1AdZd8ZQTlxWvxcKNg
         Bvp5/Zfs/hfb24IrJgEB7o+ok00/mqUO8WpGcAmONUTYoqJCLhx5FYH3yf2GhIFpL1nm
         FP8uiwX0NjdLl2YHdWWyBjaAa+jbazfpRK1j0=
Date: Tue, 7 Jul 2009 09:40:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Anton Blanchard <anton@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/2] perfcounter: Ignore the nmi call frames in the
	x86-64 backtraces
Message-ID: <20090707074057.GB6173@nowhere>
References: <1246474930-6088-1-git-send-email-fweisbec@gmail.com> <1246882668.8143.10.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246882668.8143.10.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 02:17:48PM +0200, Peter Zijlstra wrote:
> On Wed, 2009-07-01 at 21:02 +0200, Frederic Weisbecker wrote:
> 
> > +int x86_is_stack_id(int id, char *name)
> > +{
> > +	return x86_stack_ids[id - 1] == name;
> > +}
> 
> OK, this bit would need a bit of a comment explaining why this works, as
> I don't think the C language guarantees de-duplication of constant
> strings.
> 
> Therefore the above only works correctly if its passed a pointer from
> the x86_stack_ids[] array -- as it indeed is, since the string passed is
> obtained through the below method:


Right, that need some comments, I will do that with x86-32 support at the same
time.

Thanks.


 
> > +static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
> > +					unsigned *usedp, char **idp)
> > +{
> >  	unsigned k;
> >  
> >  	/*
> > @@ -61,7 +68,7 @@ static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
> >  			if (*usedp & (1U << k))
> >  				break;
> >  			*usedp |= 1U << k;
> > -			*idp = ids[k];
> > +			*idp = x86_stack_ids[k];
> >  			return (unsigned long *)end;
> >  		}
> >  		/*
> 
> 

