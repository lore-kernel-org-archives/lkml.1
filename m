Return-Path: <linux-kernel-owner+w=401wt.eu-S1752050AbXCCLvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbXCCLvG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 06:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbXCCLvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 06:51:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:13049 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbXCCLvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 06:51:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hBo5nHHpM8wr3om7ZYqPkbGg/h9+T8D0RssR0peJtmp9l8nHphpFSeSPSW/2EUJJkLpfaL5xEu/HnzNxSQ1NiOeZLl+LklBVH2yVn3uSzWpnqn/y2CHTc4gmmqpa3bfbrzuxIDBgsaUhlQmXGrxpm4ZWSWMfYFGCRM4JeyTQq1w=
Message-ID: <efa6f5910703030351i9be2e1fg2cc63e75c2e48b3d@mail.gmail.com>
Date: Sat, 3 Mar 2007 12:51:00 +0100
From: "Ihar `Philips` Filipau" <thephilips@gmail.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070303110327.GA11992@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <efa6f5910703021120ia0b8d18ne0c806eb2e73da4c@mail.gmail.com>
	 <20070303103427.GC22557@2ka.mipt.ru>
	 <efa6f5910703030258ne76cd8as8a3900fc22456a91@mail.gmail.com>
	 <20070303110327.GA11992@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/3/07, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> > >Threadlets can work with any functionas a base - if it would be
> > >recv-like it will limit possible case for parallel programming, so you
> > >can code anything in threadlets - it is not only about IO.
> >
> > What I'm trying to get to: keep things simple. The proposed
> > optimization by Ingo does nothing else but allowing AIO to probe file
> > cache - if data there to go with fast path. So why not to implement
> > what the people want - probing of cache? Because it sounds bad? But
> > they are in fact proposing precisely that just masked with "fast
> > threads".
>
> There can be other parts than just plain recv/read syscalls - you can
> create a logical processing entity and if it will block (as a whole, no
> matter where), the whole processing will continue as a new thread.
> And having different syscall to warm cache can end up in cache flush in
> between warming and processing itself.
>

I'm not talking about cache warm up. And if we do - and that the whole
freaking point of AIO - Linux IIRC pins freshly loaded clean pages
anyway. So there would be problem but only under memory pressure. If
you under memory pressure - you already lost the game and do not care
about performance/what threads you are using.

It is the whole "threadlets to threads on blocking" things doesn't
sound convincing. It sounds more like "premature optimization". But
anyway, not that I'm AIO specialist. For networking it is totally
unnecessary since most applications which care have already rate
control and buffer management built in. Network connections/sockets
allows greater level of application control on what and how they do.
Compared to blockdev's plain dumb read()/write() going through global
cache. And not that (judging from interface) AIO changes that much -
it is still dumb read() what IMHO makes no sense whatsoever to mmap()
oriented Linux.

-- 
Don't walk behind me, I may not lead.
Don't walk in front of me, I may not follow.
Just walk beside me and be my friend.
    -- Albert Camus (attributed to)
