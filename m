Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbYGaU3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbYGaU3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYGaU25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:28:57 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:46249 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbYGaU24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UE8IZQv3Sq4WR8rswyL6Z7ubpBBF239yr8Cjw/VULAMYYC9hRykaouJw/PV4/NByPr
         qfqVLrXEO64txTXfUPIGav8vREPTROpWE8NydZkoQKCG9LNBcOYQkhGtru0ZSNnKyuxO
         J4niUAfQXOSKX3nCa/kB8OhvJTNPM05oGr11g=
Date: Thu, 31 Jul 2008 16:28:49 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for July 30
Message-ID: <20080731162158.ZZRA012@mailhub.coreip.homeip.net>
References: <20080730170635.f737ffe9.sfr@canb.auug.org.au> <20080731104437.5e5669bc.akpm@linux-foundation.org> <20080731141302.ZZRA012@mailhub.coreip.homeip.net> <200807312048.57575.rjw@sisk.pl> <20080731145023.ZZRA012@mailhub.coreip.homeip.net> <alpine.LFD.1.10.0807311207000.3277@nehalem.linux-foundation.org> <20080731151625.ZZRA012@mailhub.coreip.homeip.net> <alpine.LFD.1.10.0807311235350.3277@nehalem.linux-foundation.org> <20080731155701.ZZRA012@mailhub.coreip.homeip.net> <alpine.LFD.1.10.0807311310090.3277@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807311310090.3277@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 01:16:52PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 31 Jul 2008, Dmitry Torokhov wrote:
> > 
> > Sometimes we do need to upgrade userspace though. Can we make
> > Documentation/Changes more prominent? Maybe have it published on
> > kernel.org?
> 
> We basically _never_ have to upgrade userspace that aggressively. We can 
> have a Changes file that talks about things that will eventually break 
> when we remove support for it eventually, but it should never EVER be used 
> as an excuse for "I needed to break it now".
> 
> So no, I refuse to make it any more prominent. 

OK.

> Because it would just be 
> used as an excuse for behavior that I consider unacceptable. It was 
> different back when we had 3-year development windows and people upgrading 
> from 2.4.x to 2.6.x had to learn new things, but for 2.6.26 to .27 or 
> similar it's simply not acceptable.
> 
> Look at the VFS layer. Look at how we have multiple different versions of 
> "readdir()" (well, getdents, really), and "stat()". Exactly because we 
> don't break user space.

Here we don't extend the interface though.
> 
> > It did specify the size. Something 448 more bytes than it allocated:
> > 
> >     unsigned long evbits[NBITS(KEY_MAX)];
> > 
> >     /* Check for ABS_X, ABS_Y, ABS_PRESSURE and BTN_TOOL_FINGER */
> > 
> >     SYSCALL(ret = ioctl(fd, EVIOCGBIT(0, KEY_MAX), evbits));
> > 
> > So we allocate 64 bytes on stack and then as kernel to fill it with
> > 511 bytes worth of data.
> 
> Ok, I can see how it's confused, asking for KEY_MAX _bits_. If this is the 
> main user, why not just change the definition to be in bits?
> 

Because X proper, HAL, DirectFB and many other users got it right and
changing it to mean bits would break _them_.

> > >  - help fix up the userspace driver regardless
> > 
> > In progress.
> > > 
> > >  - a year down the line, maybe breakage will be a non-issue.
> > 
> > Around when 2.6.28 is released, right? ;)
> 
> A year down the line would be 2.6.30 or so.
> 

I guess that means that we have to have that patch that spits warning
and reduces size of returned data of it detects 01ff buffer size.
Still, its uuuuugllllyyy.

> > We do need more keycodes. People are coming wioth more and more. The
> > patch following the one in question adds about 10 new kodes for remote
> > controls/phones. And we will get more.
> 
> Maybe the problem is a bad design that encourages people to just create 
> new keycodes when they really shouldn't? 

That is bigger topic. HID spec has much more events for differect
things though. FOr example the new key definitions for the phones - we
want to have a separate # key and not try to combine "shift" and "3"
and also have separate numeric keys taht don't depend on register and
NumLock state. If we don't have such keycodes we have trouble with
some european users that have numbers in upper register...

-- 
Dmitry
