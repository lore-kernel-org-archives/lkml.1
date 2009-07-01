Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbZGAV3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbZGAV3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 17:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbZGAV3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 17:29:17 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:63333 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbZGAV3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 17:29:17 -0400
X-IronPort-AV: E=Sophos;i="4.42,328,1243828800"; 
   d="scan'208";a="968524"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: [RFC v2] kernel/printk.c - handling more than one CON_BOOT
Date: Wed, 1 Jul 2009 17:31:42 -0400
User-Agent: KMail/1.9.5
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       vapier.adi@gmail.com, lethal@linux-sh.org
References: <200906290703.21539.rgetz@blackfin.uclinux.org> <200907011650.19173.rgetz@blackfin.uclinux.org> <20090701140128.7924f3c4.akpm@linux-foundation.org>
In-Reply-To: <20090701140128.7924f3c4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200907011731.42865.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 01 Jul 2009 21:28:24.0307 (UTC) FILETIME=[DD612430:01C9FA92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 1 Jul 2009 17:01, Andrew Morton pondered:
> > > I think it would be useful if we had a description of the new
> > > design, similar to your description of the "Today" behaviour
> > > above.  Perhaps as a comment over register_console()?
> > 
> > Can do - do you want it as v3 or on-top of this one?
> 
> I'm easy either way.  Ingo might have applied to one of his trees, in
> which case a replacement patch might cause him problems, dunno.

Ingo? I'm OK with either way.


> > > > This changeset allows multiple boot consoles, and changes the
> > > > functionality to, be mostly the same as the above.
> > > >  - Any number CON_BOOT consoles of can be registered
> > > >  - A "real" console will unregister all the CON_BOOT consoles
> > > >  - Once a "real" console is registered, no more CON_BOOT consoles 
> > > >    can be added (still silently rejected)
> > > 
> > > Is the "silent" rejection desirable?  Perhaps that's a
> > > programming/configuration error which the developer should be
> > > informed of?
> > 
> > That is what it is today. I would actually prefer not silent - as it 
> > would have meant 10 min that I would have saved myself trying to
> > figure out what was going on... :)
> > 
> > But when I was figuring out how things worked, and had a few too many
> > printks in register_console - I was getting BUG: "recent printk
> > recursion!" - so I just left it silent (rather than figuring this out).
> 
> OK - I was just wondering.   Whatever you think is best..

There is a difference between best and lazy. I picked lazy.

I will see if I can figure it out.

