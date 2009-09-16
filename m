Return-Path: <linux-kernel-owner+w=401wt.eu-S1759138AbZIPOTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138AbZIPOTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 10:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758000AbZIPOTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 10:19:35 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:50630 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430AbZIPOTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 10:19:31 -0400
From: Frans Pop <elendil@planet.nl>
To: Wei Chong Tan <weichong78@gmail.com>
Subject: Re: PATCH: ARCH in builddeb
Date: Wed, 16 Sep 2009 16:19:31 +0200
User-Agent: KMail/1.9.9
Cc: sam@ravnborg.org, max@stro.at, linux-kernel@vger.kernel.org
References: <31cb94fa0909132225l6cb98739o59d105ef480d1cd2@mail.gmail.com> <200909142301.17936.elendil@planet.nl>
In-Reply-To: <200909142301.17936.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909161619.33461.elendil@planet.nl>
X-OriginalArrivalTime: 16 Sep 2009 14:19:34.0370 (UTC) FILETIME=[B6F31420:01CA36D8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 September 2009, Frans Pop wrote:
> On Monday 14 September 2009, Wei Chong Tan wrote:
> > I was using "make ARCH=i386 deb-pkg" in the kernel on a 64bit machine
> > and found out that the .deb package created was _amd64.deb.
> > Consequently, I modify the builddeb script to take into account the
> > ARCH environment variable.
>
> Thanks for the patch. I'd like to give it some testing though as I fear
> it may break one other use case that currently somehow does work
> correctly.
>
> If I cross-compile for arm with EABI set in the config, the script
> currently correctly generates an armel package (probably through
> dpkg-cross).
>
> Possibly your change would override that and change it to arm. I don't
> know for sure it will go wrong, but it does need testing. I'll let you
> know.

Yes, it is as I feared. Your patch results in an "arm" package when I do a 
cross-build for "armel" (for which I must of course set ARCH to "arm" as 
armel is not a valid Linux architecture).

I agree that being able to build i386 on amd64 is a valuable option and I 
have actually run into that issue myself (and solved it by building in an 
i386 chroot).

A possible solution could be to check that CROSS_COMPILE is *not* set, but 
I'm not sure if that would be the correct solution. Input from others on 
this would be welcome.

Cheers,
FJP
