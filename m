Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZBIWIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZBIWIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 17:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbZBIWId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 17:08:33 -0500
Received: from intermatrixgroup.ru ([195.178.208.66]:48152 "EHLO
	tservice.net.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbZBIWId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 17:08:33 -0500
Date: Tue, 10 Feb 2009 01:08:30 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ian@beware.dropbear.id.au
Subject: Re: [1/1] w1: w1 temp calculation overflow fix.
Message-ID: <20090209220830.GA15633@ioremap.net>
References: <20090209214217.GA14958@ioremap.net> <20090209135641.0367a71f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209135641.0367a71f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 01:56:41PM -0800, Andrew Morton (akpm@linux-foundation.org) wrote:
> > Signed-off-by: Ian Dall <ian@beware.dropbear.id.au>
> > Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
> 
> I assumed from the above that Ian authored this patch.  Please let me
> know if that was incorrect.

> The way to track authorship is to put the originator's From: line at
> the top of the changelog.
 
Yes, Ian is the author.
I will put appropriate From: field next time, I did not know it :)

> > --- a/drivers/w1/slaves/w1_therm.c
> > +++ b/drivers/w1/slaves/w1_therm.c
> > @@ -115,7 +115,7 @@ static struct w1_therm_family_converter w1_therm_families[] = {
> >  
> >  static inline int w1_DS18B20_convert_temp(u8 rom[9])
> >  {
> > -	s16 t = (rom[1] << 8) | rom[0];
> > +	int t = ((s16)rom[1] << 8) | rom[0];
> >  	t = t*1000/16;
> >  	return t;
> >  }
> 
> It seems strange to use s16 here, but it will fix the bug.
> 
> Perhaps this function should be using plain old `unsigned' everywhere.
> 
> Please provide changelogs.  This bugfix is applicable to 2.6.28.x and
> probably earlier.  But due to the lack of any supporting information I
> am not in a position to determine whether it should be backported.
 
That's what was placed into the documentation iirc, code for the more
advanced chip works ok. This code exists for way too long, but
apparently did not grow higher than 32 degrees, so it is applicable for
the earlier trees either.

-- 
	Evgeniy Polyakov
