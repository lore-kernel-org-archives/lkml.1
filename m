Return-Path: <linux-kernel-owner+w=401wt.eu-S1762846AbZD3R7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846AbZD3R7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934131AbZD3R4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:56:09 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:60885 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934239AbZD3R4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:56:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=CO8aCasGNAkqlDEceerXVT3YXlB7kwblkiIXJ6xX/wVJztRRNycLJmRBWiEZenIfwk
         XFD0CKDZYkiDohxLdOO/EJxl+P042IEGnkibEy2tIODvlH9HPYVLJuqBKO/BHCKTBDS3
         JVcGQXyjE3iF4P4lNHVpUAfwwqs97V2UgjqwU=
From: Eric Lacombe <goretux@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [unused symbol] need to use init_mm
Date: Thu, 30 Apr 2009 19:55:54 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; x86_64; ; )
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org, davej@redhat.com,
       tglx@linutronix.de
References: <200904301232.05302.goretux@gmail.com> <20090430140957.GD21997@csn.ul.ie> <20090430144057.GA14897@elte.hu>
In-Reply-To: <20090430144057.GA14897@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904301955.55407.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009, Ingo Molnar wrote :
> * Mel Gorman <mel@csn.ul.ie> wrote:
> > On Thu, Apr 30, 2009 at 12:32:04PM +0200, Eric Lacombe wrote:
> > > Hi,
> > >
> > > Within a module I work on, I need to access to init_mm, but as it is
> > > marked UNUSED, I wonder if there is another way (an API) to access to
> > > it. Otherwise, what can I do to have this mark removed from init_mm in
> > > the mainline? as my module is really not yet ready for inclusion.
> > >
> > > Thanks in advance for your response,
> >
> > It looks to be that it was removed already, somewhat behind schedule, in
> > commit 9470565579f29486f4ed0ffa50774268b64994b0 after an initial attempt
> > was made in commit 3abf024d2abb79614d8c4cb25a70d5596f77d0ad.  I don't
> > know if there is a procedure for bringing it back but I would guess it's
> > a call for the x86 maintainers. I imagine they will want to at least
> > know;
> >
> > 1. Why do you need init_mm exported?

In brief, my module use hardware virtualization technologies (only Intel ones 
for the moment) in order to prevent the kernel from behaving maliciously 
(because of a kernel malware) and to prevent the installation of many kernel 
malwares. One of my approaches is to preserve some kernel-constrained objects: 
for instance, some simple objects like idtr, gdtr, ... or some more 
complicated objects like the kernel address space layout, ...
For the latter I use init_mm.pgd.

I wrote a paper and will talk about it at the EICAR conference (May 11th and 
12th) this year (http://www.eicar.org/conference/index.htm).

> > 2. Is there an alternative approach to using init_mm?

I don't really take the time to think about another approach, but it seems 
natural to access to init_mm.pgd. Maybe, I could access to it by other means,  
but that would certainly be ugly :/

> > 3. Assuming yes, what are the downsides?

ugliness ;) maybe kernel version dependent.

> > 4. When do you think the module will be ready for posting?  i.e. is this
> >    really something destined for mainline or some perma-out-of-tree?

It is destined for mainline as far as I'm concerned. But it needs to be 
accepted by the kernel community when it will be ready.
(I work for a french public laboratory, so it will be GPL 2 or 3 licensed 
anyway)

>
> yes, those questions have to be answered.

I hope to have adequately answered to your questions.

Best regards,

	Eric

