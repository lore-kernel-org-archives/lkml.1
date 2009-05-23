Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbZEWOfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbZEWOfl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 10:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZEWOfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 10:35:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:46950 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbZEWOfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 10:35:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :cc:subject:references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=KJz3cMPiwoDda0kdIz6A5IdF5R6h9vIiPM+a9fpsQxK86oxpIwU48CQB51coQw4W2w
         4utSoqYp5l+gWRhrpENfMSjFE9B1FnmzmpSelADjGKmrdvep0ToyqyNaoqWwYABjpeo1
         dfbiZNaZZ9r5+aCDsK1tWhkIXdHpYabkNChGI=
Message-ID: <4A1809B0.3030109@googlemail.com>
Date: Sat, 23 May 2009 16:35:28 +0200
From: Michael Riepe <michael.riepe@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: de-de, de, en-us, en
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: David Dillow <dave@thedillows.org>, Francois Romieu <romieu@fr.zoreil.com>,
       Rui Santos <rsantos@grupopie.com>,
       =?ISO-8859-15?Q?Michael_B=FCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.30-rc4] r8169: avoid losing MSI interrupts
References: <200903041828.49972.m.bueker@berlin.de> <4A0C7443.1010000@googlemail.com> <1243042174.3580.23.camel@obelisk.thedillows.org> <200905231124.28925.mb@bu3sch.de>
In-Reply-To: <200905231124.28925.mb@bu3sch.de>
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Michael Buesch wrote:

> Thanks a lot, Dave! This fixes the issue on my chip.

Yep, it's stable here as well. And even a little faster than pci=nomsi.
The only strangeness I observed is that the throughput (measured with
iperf and a single TCP connection) varies:

[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec    667 MBytes    559 Mbits/sec
[  3] 10.0-20.0 sec    803 MBytes    673 Mbits/sec
[  3] 20.0-30.0 sec    802 MBytes    673 Mbits/sec
[  3] 30.0-40.0 sec    714 MBytes    599 Mbits/sec
[  3] 40.0-50.0 sec    669 MBytes    561 Mbits/sec
[  3] 50.0-60.0 sec    791 MBytes    663 Mbits/sec
[  3]  0.0-60.0 sec  4.34 GBytes    622 Mbits/sec

In gkrellm, you can see that it actually alternates between two values.

With pci=nomsi (and without the patch) I get lower but more consistent
results:

[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec    511 MBytes    429 Mbits/sec
[  3] 10.0-20.0 sec    465 MBytes    390 Mbits/sec
[  3] 20.0-30.0 sec    481 MBytes    404 Mbits/sec
[  3] 30.0-40.0 sec    466 MBytes    391 Mbits/sec
[  3] 40.0-50.0 sec    465 MBytes    390 Mbits/sec
[  3] 50.0-60.0 sec    463 MBytes    389 Mbits/sec
[  3]  0.0-60.0 sec  2.78 GBytes    399 Mbits/sec

I suppose it's a side effect of the MSI acknowledgement loop. But who am
I to complain about higher average throughput? ;-)

> You can add my:
> 
> Tested-by: Michael Buesch <mb@bu3sch.de>

Tested-by: Michael Riepe <michael.riepe@googlemail.com>

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
