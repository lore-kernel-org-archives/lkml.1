Return-Path: <linux-kernel-owner+w=401wt.eu-S1752180AbZCKQ3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbZCKQ3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbZCKQ3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:29:06 -0400
Received: from mx1.suse.de ([195.135.220.2]:60204 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbZCKQ3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:29:04 -0400
Date: Wed, 11 Mar 2009 09:22:03 -0700
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: build issue #592 for v2.6.29-rc7-3-g559595a :multiple
	definition of `ieee80211_xmit'
Message-ID: <20090311162203.GC21831@suse.de>
References: <200903081151.40006.toralf.foerster@gmx.de> <20090308110942.GC27811@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090308110942.GC27811@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 12:09:42PM +0100, Ingo Molnar wrote:
> 
> (Cc: line extended)
> 
> * Toralf Förster <toralf.foerster@gmx.de> wrote:
> 
> > Hello,
> > 
> > the build (.config attached) failed, make ends with :
> > ...
> >   CC [M]  drivers/watchdog/wm8350_wdt.o
> >   CC [M]  drivers/watchdog/softdog.o
> >   LD      drivers/built-in.o
> > drivers/staging/built-in.o: In function `ieee80211_xmit':
> > (.text+0x6bc3d): multiple definition of `ieee80211_xmit'
> > drivers/net/built-in.o:(.text+0x19a7f): first defined here
> > make[1]: *** [drivers/built-in.o] Error 1
> > make: *** [drivers] Error 2

Yes, some of the staging drivers can't all be built into the kernel at
this time due to duplicated symbols.  I'm working on fixing this up, but
for now, it's recommended that you just build them as modules wherever
possible.

thanks,

greg k-h
