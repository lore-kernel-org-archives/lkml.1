Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbYCYWub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbYCYWub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 18:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYCYWuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 18:50:24 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:52037 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbYCYWuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 18:50:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L78Z8y7HGYEj0jTJDSAxYlvyHk4Kp7CwKB9I1LKU8Gs1XnRBqh9wwoh8YWDNIaDi/jMLIbzzdJnUg0JR+tpsXRvBG0RXB1xz6WgO+yeY0xGRtNc0LjjZwyBPIE4d4vSa0cI6m7Ya9JRuoRUuAuxSP9IzbBnRb3+ALsa5Qw+8AsI=
Message-ID: <998d0e4a0803251550k24111763ve5cfe48dc5b0fc84@mail.gmail.com>
Date: Tue, 25 Mar 2008 23:50:20 +0100
From: "J.C. Pizarro" <jcpiza@gmail.com>
To: "Chris Snook" <csnook@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Why /proc/cpuinfo doesn't print L1,L2,L3 caches?
In-Reply-To: <47E97566.5020003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <998d0e4a0803251439u4bf09fb1ye568fc1970b0200f@mail.gmail.com>
	 <47E97566.5020003@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008/3/25, Chris Snook <csnook@redhat.com> wrote:
> J.C. Pizarro wrote:
>  > $ cat /proc/cpuinfo
>  > processor       : 0
>  > vendor_id       : AuthenticAMD
>  > cpu family      : 15
>  > model           : 47
>  > model name      : AMD Athlon(tm) 64 Processor 3200+
>  > ...
>  > cache size      : 512 KB
>  > ...
>  >
>  > The cache size is currently misinformed. It's not the real size because
>  > it's 64+64+512 KiB = 640 KiB, not 512 KB.
>  >
>  > How can i know what hw-caches use the processors?
>  > The current kernel doesn't know well what hw-caches uses.
>  >
>  > The good proposal is by example (the data below are not real):
>  > * In old AMD Athlon64:
>  >
>  > cache L1        : 64 KiB I + 64 KiB D, 64 B line, direct way, ...
>  > cache L2        : 512 KiB I+D-shared, exclusive, 128 associative way, ...
>  > cache L3        : none
>  >
>  > * In Intel Core Duo:
>  > processor       : 0
>  > cache L1        : 32 KiB I + 32 KiB D, 64 B line, direct way, ...
>  > cache L2        : 2048 KiB Cores-shared, inclusive, 128 associative way, ...
>  > cache L3        : none
>  >
>  > processor       : 1
>  > cache L1        : 32 KiB I + 32 KiB D, 64 B line, direct way, ...
>  > cache L2        : 2048 KiB cores-shared, inclusive, 128 associative way, ...
>  > cache L3        : none
>  >
>  > * In Quad:
>  > processor       : 0
>  > cache L1        : 32 KiB I + 32 KiB D, 64 B line, direct way, ...
>  > cache L2        : 2048+2048 KiB pair-cores-shared, inclusive, 128
>  > associative way, ...
>  > cache L3        : none
>  > ...
>  > processor       : 3
>  > cache L1        : 32 KiB I + 32 KiB D, 64 B line, direct way, ...
>  > cache L2        : 2048+2048 KiB pair-cores-shared, inclusive, 128
>  > associative way, ...
>  > cache L3        : none
>  >
>  > It above is an example, put your symbols to /proc/cpuinfo in a
>  > convenient manner.
>  >
>  >    Good bye ;)
>
>
> I think you want this:
>
>  /sys/devices/system/cpu/cpu0/cache

Thanks, but there is not easier manner to print the properties of hw-caches
unless printing recursively this tree /sys/devices/system/cpu/cpu[0-9]+/cache/
that they are only numbers without symbolic fields.

There is not manner to know the speed (in MHz) of the L1, L2 and L3 caches.

>  /proc/cpuinfo is intended to give a general summary of certain properties of the
>  processor that tend to be particularly interesting, and present them all in one
>  place.  It is not intended to expose everything the kernel knows about every
>  processor on the system.

/proc/cpuinfo doesn't give a general summary because it gives superfluous info.

I think that it's better to refactorize /proc/cpuinfo still more.

(
   ... fields common to all present processors known by the kernel ....
       [ to warn if the values are differents between cores ]
)
(
   ... specific fields for each processor ... by example:

processor       : 0
cpu MHz         : 2000.000     # normal clocked
bogomips        : 4010.63
processor       : 1
cpu MHz         : 500.000     # underclocked for energy saving ...
bogomips        : 1003.20

)

I think that all the cores are equals in almost non-weird systems.
With this scheme, the cpuinfo's reports will be smaller than before,
and non-superfluous.

>  -- Chris
