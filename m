Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbZGJO7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbZGJO7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 10:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbZGJO7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 10:59:34 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:55246 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961AbZGJO7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 10:59:33 -0400
From: Frans Pop <elendil@planet.nl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 13012] 2.6.28.9 causes init to segfault on Debian etch; 2.6.28.8 OK
Date: Fri, 10 Jul 2009 16:59:29 +0200
User-Agent: KMail/1.9.9
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kbuild@vger.kernel.org, barryn@pobox.com,
       bugme-daemon@bugzilla.kernel.org
References: <200907100928.07369.elendil@planet.nl>
In-Reply-To: <200907100928.07369.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907101659.31813.elendil@planet.nl>
X-OriginalArrivalTime: 10 Jul 2009 14:59:32.0538 (UTC) FILETIME=[084779A0:01CA016F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 July 2009, Frans Pop wrote:
> On Thu, 9 Apr 2009, Linus Torvalds wrote:
> > On Thu, 9 Apr 2009, Andrew Morton wrote:
> > > -fwrapv killed Barry's gcc-4.1.2-compiled kernel in 2.6.27.x,
> > > 2.6.28.x and presumably 2.6.29, 2.6.30.
> >
> > Auughh. I hate compiler bugs. They're horrible to debug.
> >
> > I _think_ 'fwrapv' only really matters with gcc-4.3, so maybe we
> > could just enable it for new versions.
> >
> > HOWEVER, I also wonder if we could instead of "-fwrapv" use
> > "-fno-strict-overflow". They are apparently subtly different, and
> > maybe the bug literally only happens with -fwrapv.
> >
> > Barry, can you see if that simple "replace -fwrapv with
> > -fno-strict-overflow" works for you?

Prompted by the same suggestion from Ben Hutchings I checked this too, 
but -fno-strict-overflow was only introduced in gcc 4.2.
So using it instead of -fwrapv *would* fix the problem for gcc 4.1, but 
*only* because it would effectively do the same as the patch I proposed: 
not add an option at all for gcc 4.1.

So that change seems illogical unless there are other reasons to 
prefer -fno-strict-overflow over -fwrapv (well, it would avoid the
gcc version check).

It does however make it somewhat more logical to change the test in my 
proposed patch to also allow -fwrapv for gcc 4.2.

Cheers,
FJP
