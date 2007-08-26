Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbXHZQad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbXHZQad (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 12:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbXHZQaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 12:30:25 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36711 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbXHZQaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 12:30:25 -0400
Date: Sun, 26 Aug 2007 18:30:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Fred Tyler <fredty8@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Slow, persistent memory leak in 2.6.20
In-Reply-To: <466ad3f90708260916x5d19d0d3hd828e63520960192@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708261828540.15614@fbirervta.pbzchgretzou.qr>
References: <466ad3f90708260739v645294b9t641cb8258dcc4f4@mail.gmail.com> 
 <466ad3f90708260851u5d8ac58duc4072b71ebf78fc8@mail.gmail.com> 
 <Pine.LNX.4.64.0708261752260.15614@fbirervta.pbzchgretzou.qr>
 <466ad3f90708260916x5d19d0d3hd828e63520960192@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 26 2007 12:16, Fred Tyler wrote:
>> Please rule out filesystem caches by issuing
>>         sync;
>>         echo 3 >/proc/sys/vm/drop_caches;
>
>(Sorry if this goes to the list twice... Mailer problems.)
alright..

>Ok, I did this on a non-production machine that has only been up for a
>few hours, and here's what happened:
>
>======== Before =========
>
>$ free -m
>            total       used       free     shared    buffers     cached
>Mem:           878        824         54          0        111        422
>-/+ buffers/cache:        290        587
>Swap:           63          0         63
>
>
>======== After ========
>
>root@b0$ free -m
>            total       used       free     shared    buffers     cached
>Mem:           878         47        830          0          6          4
>-/+ buffers/cache:         36        841
>Swap:           63          0         63
>
>======================
>
>So, I guess it worked? (I don't know what was supposed to happen, but
>memory usage dropped significantly when I did this.)

So I guess you are not seeing any memory leak at all, but just the regular
caching?

>However, I'm not sure this staging machine has been up long enough or
>doing enough to exhibit the problem. I can try this on my production
>servers (the ones I provided graphs for) late tonight, but how safe is
>running this command? Does it permanently disable file caching? Do I
>need to reset it afterwards? If I stop all services (databases,

drop_cache is a trigger, not a setting. Hence your RAM will be used again
after you have used drop_caches.

>logging, etc) first, am I protected against data loss?


	Jan
-- 
