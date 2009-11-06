Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbZKFFh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbZKFFh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 00:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZKFFh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 00:37:58 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:41744 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZKFFh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 00:37:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=d7g8LWCeB976HH8LLarHoTWmXfjcp83kKEzlP9yn/8lLAE5h8XHXtTgNGYy8h7UDpx
         jTDZdTj9XovXnci04w4Y4uIVpH5BnWR5FksXTCwaa6M+Pvufy4ZhSOPlcdX66wQ9sDY5
         mgfpRM8Fn9PPstXsfa7cXPzS5CdhHZhLEz2Zo=
Message-ID: <4AF3B637.9060002@gmail.com>
Date: Fri, 06 Nov 2009 06:37:59 +0100
From: Carmelo Amoroso <carmelo73@gmail.com>
Reply-To: carmelo73@gmail.com
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
CC: linux-kbuild <linux-kbuild@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Fast LKM symbol resolution
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
In-Reply-To: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Here's my latest code using binary search for symbol resolution.  This
> version has benefited from a little more testing (heh), in particular
> running on a simulated ARM system.
> 
>     web: <http://github.com/sourcejedi/linux-2.6/commits/module-V2-beta1>
> 
>     git clone git://github.com/sourcejedi/linux-2.6.git module-V2-beta1
> 
> As before, it saves 0.3s boot time for a modular kernel on my netbook
> (630 Mhz Celeron M).  On that system it represents something like 90%
> of the maximum possible speedup.  It is claimed that slower systems
> would benefit from a further speedup (e.g. using hash tables instead),
> but we don't have any numbers to illustrate this yet.
> 
> 

Hi Alan,

I'm going to complete the port of the hash table work against the mainline
(I had an implementation based on older 2.6.23.17 and 2.6.30).
I have figures on sh4 arch (2.6.23.17) but I would like to provide you with benchmarks
using the mainline on x86 too.
In my implementation there are not arch specific parts.

I intend to provide this solution as optional for now, so this will force some
#ifdef in the code that could make it less clean, but if the solution is valuable,
I could do a code tidy-up later easily.

The work to use GNU hash & bloom filtering is almost completed too, but it needs
some more tests, so the first patches I'll send are based on the SysV hash table.

Apologies for the delay in providing patches.

Carmelo
