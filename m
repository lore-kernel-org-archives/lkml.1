Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbZHTC3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbZHTC3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 22:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbZHTC33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 22:29:29 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:25288 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbZHTC32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 22:29:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=BBwrgwMU0Ltc9YdNiKQii3ljQ5sXnLs3qEKK4zRaupnEdI28alvtkWQhh3qr7hPgFE
         J5OENTuedcRuEr+TREwNOFm84axag1ZNQbH6XK2S4e4s6KopCL9pDGJBZgT7X82G6ZX5
         f36TSzhI37eE0k5/tDtWpSvgr6deNlEd2yedo=
MIME-Version: 1.0
In-Reply-To: <20090819164029.GZ19938@edu.joroinen.fi>
References: <20090819140848.GW19938@edu.joroinen.fi> <200908192247543597389@usish.com> 
	<20090819164029.GZ19938@edu.joroinen.fi>
From: Drew <drew.kay@gmail.com>
Date: Wed, 19 Aug 2009 19:29:07 -0700
Message-ID: <c268e4660908191929u3f11c733oc68a0d50a3e5aca8@mail.gmail.com>
Subject: Re: Re: Performance issues with Areca 1680 SAS Controllers
To: =?UTF-8?B?UGFzaSBLw6Rya2vDpGluZW4=?= <pasik@iki.fi>
Cc: Wang Jinpu <jack_wang@usish.com>, Nick Cheng <nick.cheng@areca.com.tw>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Fuckner <michael@fuckner.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Erich Chen <erich@areca.com.tw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem is while Areca is doing the flushing _all_ IOs are really slow,
> including the other raid-10 array for the OS, which uses totally separate physical disks.
>
> Opening another shell in screen takes at least 30 seconds, starting "top"
> takes forever etc..
>
> While Areca is flushing the caches (and all the IOs are slow), "iostat 1"
> doesn't show any "leftover" IOs from the benchmark. So the benchmark was
> really using direct IO, bypassing kernel caches.
>
> I tried with different io-schedulers (cfq,deadline,noop) but they didn't
> have big effect.. which makes sense, since the OS/kernel is not doing any
> big IO when the 'stalling' happens.
>
> Is there some way to make Areca NOT use all cpu-power for cache flushing?

Is top showing 100% cpu usage?

It wouldn't surprise me if the Areca's internal bus / processor is
getting swamped. With the RAID60 chewing through two PQ calculations
over 14 disks I'd expect the performance of other arrays on the
controller would take a hit

I've seen similar symptoms when moving massive amounts of data between
disks on my servers. IO maxes out the bus, system responsiveness goes
down as evidenced by slowly loading apps, and top still shows minimal
CPU usage.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
