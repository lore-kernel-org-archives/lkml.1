Return-Path: <linux-kernel-owner+w=401wt.eu-S932932AbXBVBFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932AbXBVBFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 20:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932846AbXBVBFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 20:05:48 -0500
Received: from mail.kroah.org ([69.55.234.183]:54074 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932932AbXBVBFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 20:05:47 -0500
Date: Wed, 21 Feb 2007 16:18:09 -0800
From: Greg KH <greg@kroah.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "YOSHIFUJI Hideaki / ?$B5HF#1QL@" <yoshfuji@linux-ipv6.org>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: request_module: runaway loop modprobe net-pf-1 (is Re: Linux 2.6.21-rc1)
Message-ID: <20070222001809.GB30444@kroah.com>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070222.012356.27907445.yoshfuji@linux-ipv6.org> <87ps8372bf.fsf@duaron.myhome.or.jp> <20070221203652.GB17830@kroah.com> <87abz75hzs.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87abz75hzs.fsf@duaron.myhome.or.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 06:16:23AM +0900, OGAWA Hirofumi wrote:
> Greg KH <greg@kroah.com> writes:
> 
> > On Thu, Feb 22, 2007 at 04:12:04AM +0900, OGAWA Hirofumi wrote:
> >> YOSHIFUJI Hideaki / ?$B5HF#1QL@ <yoshfuji@linux-ipv6.org> writes:
> >> 
> >> > In article <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> (at Tue, 20 Feb 2007 20:53:45 -0800 (PST)), Linus Torvalds <torvalds@linux-foundation.org> says:
> >> >
> >> >> But there's a ton of architecture updates (arm, mips, powerpc, x86, you 
> >> >> name it), ACPI updates, and lots of driver work. And just a lot of 
> >> >> cleanups.
> >> >
> >> > I cannot boot 2.6.21-rc1; it falls into OOM-Killer.
> >> >
> >> > Interesting error message I can see is:
> >> >    request_module: runaway loop modprobe net-pf-1
> >> >
> >> > After bisecting, the commit
> >> >   Driver core: let request_module() send a /sys/modules/kmod/-uevent
> >> > (id c353c3fb0700a3c17ea2b0237710a184232ccd7f) is to blame.
> >> >
> >> > Reverting it fixes the issue to me.
> >> 
> >> /sbin/hotplug needs some module, but request_module() call /sbin/hotplug loop?
> >> Hm.. does the patch fix the problem?
> >
> > How does it loop?
> 
> E.g. something calls the request_modle(), and if hotplug is using
> socket(PF_UNIX) and af_unix is module, it also calls request_modle()?
> 
> Just my guess though...

Ugh, why does anyone make af_unix a module these days.  I thought only
Debian was that foolish...  :)

It will be interesting to see if this fixes the issue or not.

thanks,

greg k-h
