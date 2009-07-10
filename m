Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbZGJQxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbZGJQxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 12:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbZGJQww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:52:52 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:21327 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbZGJQww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:52:52 -0400
X-IronPort-AV: E=Sophos;i="4.42,379,1243828800"; 
   d="scan'208";a="3700163"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "David Howells" <dhowells@redhat.com>
Subject: Re: truncate on MAP_SHARED files in ramfs filesystems on no-mmu
Date: Fri, 10 Jul 2009 12:56:13 -0400
User-Agent: KMail/1.9.5
CC: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>
References: <8bd0f97a0907090822g1533e9dt97c3f29ccaf4945b@mail.gmail.com> <24005.1247134018@redhat.com> <24988.1247155628@redhat.com>
In-Reply-To: <24988.1247155628@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200907101256.13881.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 10 Jul 2009 16:52:50.0230 (UTC) FILETIME=[DC04F560:01CA017E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 9 Jul 2009 12:07, David Howells pondered:
> Note that it would be very easy to add (if such does not already exist)
> an LTP test that creates a file, expands it, maps it, shrinks it and then
> attempts to alter the removed part of the mapping in the expectation 
> of receiving a SIGBUS.
> 
> As it stands, such a test will work on MMU, but go wrong on NOMMU in a
> different way in these two cases.  With the current behaviour, the
> shrink request will be rejected, but the system will survive.  With your
> proposed behaviour, the system will potentially be wrecked.
> 
> The NOMMU situation behaves differently to the MMU situation in either
> case.

I guess what we were looking at - was the normal case of when userspace 
doesn't go wrong.

The kernel (today in noMMU) assumes the userspace is going to do something bad 
after it does the shrink - but for those people who are using things 
properly - it doesn't allow it to work at all.
