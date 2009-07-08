Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbZGHFAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbZGHFAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 01:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbZGHFAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 01:00:36 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:62631 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819AbZGHFAg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 01:00:36 -0400
From: Frans Pop <elendil@planet.nl>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: [Bug #13667] drm: display arifacts when X.Org is stopped
Date: Wed, 8 Jul 2009 07:00:32 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera> <200907080232.04551.elendil@planet.nl> <21d7e9970907071950n27979df6j44444edd8528a598@mail.gmail.com>
In-Reply-To: <21d7e9970907071950n27979df6j44444edd8528a598@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200907080700.33120.elendil@planet.nl>
X-OriginalArrivalTime: 08 Jul 2009 05:00:34.0020 (UTC) FILETIME=[066D5240:01C9FF89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 July 2009, Dave Airlie wrote:
> On Wed, Jul 8, 2009 at 10:32 AM, Frans Pop<elendil@planet.nl> wrote:
> > On Tuesday 07 July 2009, Rafael J. Wysocki wrote:
> >> The following bug entry is on the current list of known regressions
> >> from 2.6.30.  Please verify if it still should be listed and let me
> >> know (either way).
> >>
> >> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13667
> >> Subject       : drm: display arifacts when X.Org is stopped
> >> Submitter     : Frans Pop <elendil@planet.nl>
> >> Date          : 2009-06-27 18:52 (10 days old)
> >> References    : http://lkml.org/lkml/2009/6/27/105
> >
> > Problem is still there with -rc2. Dave said he'd try to reproduce,
> > but I've not heard back from him yet.
>
> Don't suppose you have a 32-bit install you could also test with?

You're in luck...
I also get artifacts, though less severe, with .31-rc2 on my Toshiba 
Satellite A40 (32-bit kernel) during logout from X.Org. The switch is 
clean with .30.

> Hopefully I can reproduce it on my box locally, otherwise its really
> messy dealing with 2 drivers smashing on the same hw.

Not sure why you're saying that. I would think VESA fb + X.Org is quite 
common and also a very valid use case [1]. How else would you get the 
pretty kernel boot logo? ;-)

> btw you get any wierd text mode issues without vesafb?

If I boot .31-rc2 without vga=791 I don't get the artifacts. The artifacts 
also do not appear if I boot with 'nopat'. Checked on both systems.

Note that I reported a similar issue once before, also reproducible on 
both systems. In that case it was a bug in PAT which was eventually fixed. 
See: http://bugzilla.kernel.org/show_bug.cgi?id=10843.

Given that 'nopat' helps, you may want to check with Suresh on this one.

Cheers,
FJP

[1] I'd even go so far as to feel it should be a standard test case for 
video driver developers, given that this is the third time it's shown 
regressions :-) For the third case the bug was in the X.Org i830 driver: 
http://bugs.freedesktop.org/show_bug.cgi?id=14481.
