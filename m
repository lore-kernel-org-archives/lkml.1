Return-Path: <linux-kernel-owner+w=401wt.eu-S1759883AbYDKNNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883AbYDKNNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 09:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbYDKNNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 09:13:47 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:31719 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbYDKNNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 09:13:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k3Le3YYIZTO4e1KUAoX/z/OE7yG7nDjBsaK628BlAK228r+JOF1XOyLVQlS709894x51ixHAwMkREq087fLgCTibH1LB9+xTfizUMacnc7FF8iyf/Nc12SLG1a4ENx/oeiwNprfNS/1olBTje2nFlKM6rifbfrZqtpzdj3nT5eo=
Message-ID: <cf40c6a90804110613v46de93f2nea1b2376bbd48953@mail.gmail.com>
Date: Fri, 11 Apr 2008 15:13:38 +0200
From: "Andreas Grimm" <agrimm61@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: VM - a plenty of inactive memory
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <874pabrx6b.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cf40c6a90804090213u55491ceay9b211d75d74dc29c@mail.gmail.com>
	 <874pabrx6b.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

i investigated this further. The tunables swappiness, drop_caches etc.
are no options to solve this. The problem is becoming very unpleasent,
because the system isn't able to cache that much:

The 16GB system (expected behaviour):
MemTotal:     16619808 kB
MemFree:       4490032 kB
Cached:        6929448 kB
Inactive:      1670812 kB

The 32GB system :
MemTotal:     33265916 kB
MemFree:        600000 kB
Cached:        1561124 kB
Inactive:     25873128 kB

Don't you think this is insane? Wasting 25GB at the expense of caching
(compare the cached value)? I'm clueless about this issue. Who (which
process) owns that memory? Is there a way to flush this inactive
memory? I assume that this memory hasn't been reclaimed for days,
because the amount of inactive memory is at this level for days now.

All values in /proc/sys/vm are at the defaults again, on both systems.

Any help would be appreciated.

Andreas

2008/4/9, Johannes Weiner <hannes@saeurebad.de>:
> Hi,
>
>
>  "Andreas Grimm" <agrimm61@gmail.com> writes:
>
>  > Hello everybody,
>  >
>  > i got a weird problem with one of my servers. It's a Intel SR2500AL
>  > with 32GB of RAM.
>  > Looking at the memory usage of the system, something is going totally
>  > wrong. The crucial numbers from /proc/meminfo are:
>  >
>  > MemTotal: 33265916 kB
>  > MemFree: 416168 kB
>  > Inactive: 24630428 kB (24GB? whooaaa)
>  >
>  > Another system with only 16GB, same amount of users and load, shows a
>  > more normal behaviour:
>  >
>  > MemTotal: 16619808 kB
>  > MemFree: 6912676 kB
>  > Inactive: 1774364 kB
>  >
>  > Why does the 32GB-System have this plenty of inactive memory. Is there
>  > a way to find out, what the kernel is holding in readiness (that's the
>  > definition of inactive memory afaik)?
>
>
> Inactive pages are marked in use but haven't been touched for some time.
>  These are candidates for memory reclaiming.
>
>  If nothing memory consuming happens, the kswapd should reclaim them back
>  eventually.
>
>         Hannes
>
