Return-Path: <linux-kernel-owner+w=401wt.eu-S1752171AbZETEc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbZETEc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 00:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbZETEcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 00:32:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:37403 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbZETEcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 00:32:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=VaTff0wlhy5epG/Ddu7NyPr/lQZJRLVwq/NWj7F6TZQ6stG9UXRt+ziTciZJQCaKLF
         FTAcJOG+rnaZ18qqFxEK1fhAJQrlOXZHjJ5Dv3IU17Mo2quciY5oO1KoPMqr3nOm0zJO
         IppfnNh35B0EQ3N2AyCxFanBUXzmI57eS59mE=
Date: Tue, 19 May 2009 21:32:15 -0700
From: Chris Sanford <crsanford@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       peterz@infradead.org
Subject: Re: [PATCH] include KERN_* constant in printk calls
Message-ID: <20090520043215.GA3077@chrisubuntu-laptop>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, peterz@infradead.org
References: <20090518233121.GC3109@chrisubuntu-laptop> <20090519090049.GB9388@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090519090049.GB9388@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19 09 11:00, Ingo Molnar wrote:
> 
> * Chris Sanford <crsanford@gmail.com> wrote:
> 
> > Add the KERN_CONT constant to two printk calls.
> > 
> > Signed-off-by: Chris Sanford <crsanford@gmail.com>
> > 
> > ---
> > 
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 26efa47..6a2ed16 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -7319,7 +7319,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
> >  	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
> >  
> >  	if (!(sd->flags & SD_LOAD_BALANCE)) {
> > -		printk("does not load-balance\n");
> > +		printk(KERN_CONT "does not load-balance\n");
> >  		if (sd->parent)
> >  			printk(KERN_ERR "ERROR: !SD_LOAD_BALANCE domain"
> >  					" has parent");
> > @@ -7340,7 +7340,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
> >  	printk(KERN_DEBUG "%*s groups:", level + 1, "");
> >  	do {
> >  		if (!group) {
> > -			printk("\n");
> > +			printk(KERN_CONT "\n");
> >  			printk(KERN_ERR "ERROR: group is NULL\n");
> >  			break;
> 
> Please use pr_cont() - and while at it, perhaps convert all other 
> printk()s in sched.c from KERN_* to the pr_*() notation as well?
> 
> Thanks,
> 
> 	Ingo
> --

The KERN_DEBUG constant is used 5 times when DEBUG is undefined. 
Doing a straight conversion from printk(KERN_DEBUG to pr_debug( will
result in no messages being printed. Should these calls have a different
message type, should DEBUG be defined, or should something else be done?
Thanks,
Chris
