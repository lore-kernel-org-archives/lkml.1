Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbXG2CWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbXG2CWA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 22:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbXG2CVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 22:21:50 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3262 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481AbXG2CVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 22:21:49 -0400
Date: Sat, 28 Jul 2007 22:21:02 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Martin Pitt <martin.pitt@ubuntu.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, wwoods@redhat.com,
       Ben Collins <ben.collins@ubuntu.com>
Subject: Re: [PATCH 2/3] core_pattern: allow passing of arguments to user mode helper when core_pattern is a pipe
Message-ID: <20070729022102.GA11864@hmsreliant.homelinux.net>
References: <20070727200746.GC18946@hmsreliant.homelinux.net> <20070728092355.GA5808@piware.de> <20070728134627.GA10006@hmsreliant.homelinux.net> <20070728161725.GA5836@piware.de> <20070728172142.GA10555@hmsreliant.homelinux.net> <46ABC892.2060903@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46ABC892.2060903@goop.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2007 at 03:52:02PM -0700, Jeremy Fitzhardinge wrote:
> Neil Horman wrote:
> > Jeremy asked that I make a patch next week to address split_argv's requirement
> > that the argc parameter be non-NULL.  I'll be fixing that next week, and what I
> > can do is further enhance it such that it ignores spaces in quoted strings,
> > which should address the case that concerns you.  I.E I can make split_argv
> > behave such that:
> > echo "|\"foo bar\" --pid %p" > /proc/sys/kernel/core_pattern
> > results in the following argv:
> > {{"foo bar"}, {"--pid"}, {"1234"}}
> >
> > Which I think handles what you are looking for.
> >   
> 
> No, please don't.  My original argv_split did that, and it was just way
> too complex.  If you need complex quoting, you can always point it at a
> shell script and handle it there.
> 
>     J

Ok, well then, it seems this corner case is much too harry to just fix up
immediately.  Given that we certainly don't handle quoted strings now, and the
fact that this is a case that will almost never come up, and can be esaily
worked around, lets address it at some time after we get this base functionality
in place

Regards
Neil


-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
