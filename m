Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZJ0O5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZJ0O5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbZJ0O5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:57:48 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:49839 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbZJ0O5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:57:47 -0400
Message-ID: <4AE70A6D.8060700@s5r6.in-berlin.de>
Date: Tue, 27 Oct 2009 15:57:49 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: "Leonidas ." <leonidas137@gmail.com>
CC: Michael Schnell <mschnell@lumino.de>, Noah Watkins <noah@noahdesu.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Difference between atomic operations and memory barriers
References: <f22d86810910261019yc77dbf0sa7688a98e7b98267@mail.gmail.com>	 <7ADB5FD7-9C97-4987-BC20-997258B25FD2@noahdesu.com>	 <f22d86810910261122j6c9e57e8pd4a257090f65c727@mail.gmail.com>	 <4AE5F1D2.9030908@s5r6.in-berlin.de>	 <f22d86810910261205r232db5d4re97a54827c7adab3@mail.gmail.com>	 <4AE6C998.9040405@lumino.de> <f22d86810910270323m6e004576ya4da96afc02e3d07@mail.gmail.com>
In-Reply-To: <f22d86810910270323m6e004576ya4da96afc02e3d07@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leonidas . wrote:
> On Tue, Oct 27, 2009 at 3:21 AM, Michael Schnell <mschnell@lumino.de> wrote:
>> Leonidas . wrote:
>>>
>>> any_t *ptr = something;
>>>
>>> is always atomic even on SMPs without using locks, barriers then my
>>> doubt is cleared. Thanks.
>>
>> I assume that this only holds if the pointer (not the thing it points
>> to) is denoted as volatile.

  - Atomic access (either old or new value is visible to CPUs or
    devices, but never any intermediary, half-baked value),
  - memory barrier (enforced order of accesses),
  - volatile qualifier (disabled compiler optimization of accesses)

are three different concepts.

We rely on atomic pointer load and store all over the kernel, yet never
qualify them as "volatile".  (A look into the C language spec might
bring clarity here.  I don't have the spec at hand alas.)

> I dont think so,  volatile would only ensure no caching, so some cpus
> might see the cached pointer (this is where you would want to use
> barriers), but pointer assignment would still be atomic.

What "volatile" ensures or not ensures is not that well defined in the C
language specification as far as I recall prior discussion.  Its precise
effects are compiler dependent.  You are right in so far as volatile
(given or missing) does not change whether an access is guaranteed
atomic or not.  Since it affects compiler optimizations, I think it
could possibly affect atomicity of accesses which were never guaranteed
to be atomic.  But this should not be interesting to 99.99% of all
kernel coders because they better use guaranteed atomic accesses when
they really need them.  (E.g. <linux/atomic.h> or pointer load/ store.)
-- 
Stefan Richter
-=====-==--= =-=- ==-==
http://arcgraph.de/sr/
