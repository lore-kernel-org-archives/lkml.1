Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbZFQInv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbZFQInv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbZFQIno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:43:44 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:54313 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbZFQInn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:43:43 -0400
Message-ID: <4A38ACC0.3060501@msgid.tls.msk.ru>
Date: Wed, 17 Jun 2009 12:43:44 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29.1: nfsd: page allocation failure - nfsd or kernel problem?
References: <alpine.DEB.2.00.0906161203160.27742@p34.internal.lan> <alpine.DEB.2.00.0906161205260.27742@p34.internal.lan> <4A37FE48.6070306@msgid.tls.msk.ru>
In-Reply-To: <4A37FE48.6070306@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> Justin Piszcz wrote:
>> Package: nfs-kernel-server
>> Version: 1.1.6-1
>> Distribution: Debian Testing
>> Architecture: 64-bit
>>
>> [6042655.755870] Pid: 7093, comm: nfsd Not tainted 2.6.29.1 #4
>> [6042655.755872] Call Trace:
>> [6042655.755874]  <IRQ>  [<ffffffff802850fd>]  
>> __alloc_pages_internal+0x3dd/0x4e0
>> [6042655.755885]  [<ffffffff802a738b>] cache_alloc_refill+0x2fb/0x570
>> [6042655.755887]  [<ffffffff802a76db>] __kmalloc+0xdb/0xe0
> 
> Was about to send this same report.
> 
> The thing continues servicing files it seems, but after some quite
> good delay.
> 
> This happens after massive amount of writes.  2.6.29.4 does the
> same thing.  Here it is, for comparison:
> 
> Jun 13 17:06:42 gnome vmunix: nfsd: page allocation failure. order:0, mode:0x20
> Jun 13 17:06:42 gnome vmunix: Call Trace:
> Jun 13 17:06:42 gnome vmunix:  <IRQ>  [<ffffffff8029559d>]  __alloc_pages_internal+0x3fd/0x500
> Jun 13 17:06:42 gnome vmunix:  [<ffffffff802bd4c3>]  cache_alloc_refill+0x313/0x5c0
> Jun 13 17:06:42 gnome vmunix:  [<ffffffff802bd873>] __kmalloc+0x103/0x110
> Jun 13 17:06:42 gnome vmunix:  [<ffffffff803dca6d>] __alloc_skb+0x6d/0x150
...

Justin, by the way, what's the underlying filesystem on the server?

I've seen this error on 2 machines already (both running 2.6.29.x x86-64),
and in both cases the filesystem on the server was xfs.  May this be
related somehow to http://bugzilla.kernel.org/show_bug.cgi?id=13375 ?
That one is different, but also about xfs and nfs.  I'm trying to
reproduce the problem on different filesystem...

/mjt
