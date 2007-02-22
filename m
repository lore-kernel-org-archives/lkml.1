Return-Path: <linux-kernel-owner+w=401wt.eu-S1945906AbXBVGJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945906AbXBVGJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 01:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422833AbXBVGJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 01:09:32 -0500
Received: from mx1.suse.de ([195.135.220.2]:48427 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422832AbXBVGJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 01:09:31 -0500
Date: Wed, 21 Feb 2007 22:08:03 -0800
From: Greg KH <greg@kroah.com>
To: "YOSHIFUJI Hideaki / ?$B5HF#1QL@" <yoshfuji@linux-ipv6.org>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org,
       kay.sievers@vrfy.org
Subject: Re: request_module: runaway loop modprobe net-pf-1 (is Re: Linux 2.6.21-rc1)
Message-ID: <20070222060803.GD27767@kroah.com>
References: <20070222.012356.27907445.yoshfuji@linux-ipv6.org> <87ps8372bf.fsf@duaron.myhome.or.jp> <20070222.110440.47345562.yoshfuji@linux-ipv6.org> <20070222.123417.79213825.yoshfuji@linux-ipv6.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070222.123417.79213825.yoshfuji@linux-ipv6.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 12:34:17PM +0900, YOSHIFUJI Hideaki / ?$B5HF#1QL@ wrote:
> In article <20070222.110440.47345562.yoshfuji@linux-ipv6.org> (at Thu, 22 Feb 2007 11:04:40 +0900 (JST)), YOSHIFUJI Hideaki / ?$B5HF#1QL@ <yoshfuji@linux-ipv6.org> says:
> 
> > In article <87ps8372bf.fsf@duaron.myhome.or.jp> (at Thu, 22 Feb 2007 04:12:04 +0900), OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> says:
> > 
> > > YOSHIFUJI Hideaki / ?$B5HF#1QL@ <yoshfuji@linux-ipv6.org> writes:
> > > 
> > > > In article <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> (at Tue, 20 Feb 2007 20:53:45 -0800 (PST)), Linus Torvalds <torvalds@linux-foundation.org> says:
> > > >
> > > >> But there's a ton of architecture updates (arm, mips, powerpc, x86, you 
> > > >> name it), ACPI updates, and lots of driver work. And just a lot of 
> > > >> cleanups.
> > > >
> > > > I cannot boot 2.6.21-rc1; it falls into OOM-Killer.
> > > >
> > > > Interesting error message I can see is:
> > > >    request_module: runaway loop modprobe net-pf-1
> > > >
> > > > After bisecting, the commit
> > > >   Driver core: let request_module() send a /sys/modules/kmod/-uevent
> > > > (id c353c3fb0700a3c17ea2b0237710a184232ccd7f) is to blame.
> > > >
> > > > Reverting it fixes the issue to me.
> > > 
> > > /sbin/hotplug needs some module, but request_module() call /sbin/hotplug loop?
> > > Hm.. does the patch fix the problem?
> > 
> > Yes, it absolutely fixes the issue.
> 
> Several options:
> 
> - To revert the changeset to blame

No.

> - To apply Ogawa-san's (or other appropriate) patch

His patch just avoids the issue, but isn't correct.

> - To select UNIX in init/Kconfig:KMOD

I like this one, but some people might still want it as a module (I
really don't know why, does anyone else???)

> I think it would be a good idea to rate-limit frequency of requesing a
> single module, anyway.

Yes, if we can detect the loop, that would be best.

Or, maybe the easiest thing is to just not do the netlink call if it's
asking for the network module?  :)

Any other suggestions or thoughts?

thanks,

greg k-h
