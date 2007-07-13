Return-Path: <linux-kernel-owner+w=401wt.eu-S936118AbXGMHPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936118AbXGMHPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 03:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbXGMHP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 03:15:29 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:48825 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbXGMHP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 03:15:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=s3M4/zseHeHh2fVBW6ONuc4Y9Urt8DTSY90unTYE79VAXgR7RcwT/QauoznjGaUj+uWVfN/Rg9pRwzFcEhEmddAH2ob3mVnCYDhC0+vnjDX+1Wk+/Jxq66gLiZvje6CraqV7e00tQHMzf2fwrMZ8GfV8f0EyPLeYTF+KvSMnisI=
Date: Fri, 13 Jul 2007 03:15:12 -0400
To: david@lang.hm
Cc: Joseph Fannin <jfannin@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: Hibernating To Swap Considered Harmful
Message-ID: <20070713071512.GB29055@nineveh.local>
Mail-Followup-To: david@lang.hm, Joseph Fannin <jfannin@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Huang, Ying" <ying.huang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
	Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
	linux-pm@lists.linux-foundation.org
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <200707121453.49616.rjw@sisk.pl> <Pine.LNX.4.64.0707121150460.25614@asgard.lang.hm> <200707122134.29991.rjw@sisk.pl> <Pine.LNX.4.64.0707121953440.25614@asgard.lang.hm> <20070713054244.GA20082@nineveh.local> <Pine.LNX.4.64.0707122250170.25614@asgard.lang.hm> <20070713062039.GA29055@nineveh.local> <Pine.LNX.4.64.0707122319270.25614@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707122319270.25614@asgard.lang.hm>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: jfannin@gmail.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 11:27:41PM -0700, david@lang.hm wrote:
> On Fri, 13 Jul 2007, Joseph Fannin wrote:
>
> >On Thu, Jul 12, 2007 at 10:57:04PM -0700, david@lang.hm wrote:
> >>On Fri, 13 Jul 2007, Joseph Fannin wrote:
> >>
> >>the only justification I have heard for why the hibernate image must be
> >>written to the swap partition is backwards compatibility (i.e., we've
> >>always done it that way)
> >>
> >>if you are going to reserve disk space for hibernation, what is so bad
> >>about useing a normal partition?
> >>
> >   You have to either repartition when you upgrade your memory, or
> >waste a bunch of disk space with a partition as large as you think
> >your RAM might ever expand to.
>
> memory upgrades are rare and tools are available nowdays to resize linux
> partitions.

I was recently involved in a week long headache that resulted from
a botched filesystem resizing.  I didn't have backups (most people
don't) and I lost a lot.

I did get the chance to recreate my ext3 filesystem with 256k
inodes, as seen in ext4.  Other than the kernel and e2fsprogs, every
tool I point at the new filesystem pukes and dies, in no particular
order.

So:  bring a system down for hours to perform a dangerous operation
with tools that may be out of date, or spend five minutes with "dd" as
root on a running system -- making use of features supported by the
kernel for years?

Some people think memory changes are important enough to write
code to allow memory hotplug.  My hardware doesn't support that, but
some people have been bandying about the idea of
hibernate->hardware change->resume.

> >   Swap/hibernate files can be created, deleted, and resized without
> >partitioning.
>
> if you just use the hibernate file as a reserved set of blocks and never
> touch them from the main OS things will work, but if you do anything that
> could put those blocks into the OS write cache all bets are off.

Well don't do that then.  No one should have permission to open
those files anyway, they're full of privledged data, just like the
nodes in /dev.

If the kernel's caching swap, that's... just perverse.

> >   Also: not all platforms support a large number of partitions.
> >It's not academic -- Intel Macintoshes are limited to four, with two
> >taken by Mac OS.  Add Windows and a Linux /, and you're out --
> >there's no room for a swap file.
>
> interesting, I didn't know that. I know that the Tivo's use Mac style
> partition tables and they have many partitions (10+). it seems odd that
> when switching from powerpc to x86 that they would lock themselves down
> like that. are you sure that they can't have extended partitions like
> standard PC's? it seems odd that they would have such a special partition
> table type if windows can access it.

Intel Macs use GPT partition tables, which support a huge number
of primary partitions, and so don't support secondary partitions.

32bit Windows does not support GPT, so PC-style MBR partition tables
must also be used.  GPT was designed to coexist with MBR tools, so
this mostly works, but you're limited to the union of supported
features -- 4 primary partitions, no secondaries.

--
Joseph Fannin
jfannin@gmail.com

