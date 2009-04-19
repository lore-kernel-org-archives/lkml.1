Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbZDSUET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbZDSUET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 16:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814AbZDSUED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 16:04:03 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:46240 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbZDSUEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 16:04:01 -0400
Date: Sun, 19 Apr 2009 17:03:03 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Mark Lord <lkml@rtr.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Quick question about libata and hdparm
Message-ID: <20090419200303.GA2891@ime.usp.br>
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br> <49EB1A33.7050808@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49EB1A33.7050808@rtr.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 19 2009, Mark Lord wrote:
> Rogério Brito wrote:
>> Using the usual IDE drivers, I can use/query various parameters with  
>> hdparm, like, for instance, the -m option, the -c option or even  
>> disabling DMA. With the libata drivers, this is all that I get:
(...)
>
> Nearly all of the hdparm flags work fine with libata and SATA/PATA
> drives.  Among the *very few* that do not, are the -m and -d flags.

Hummm, the -m switch would be very important in the case of a slow ppc
based NAS that I have here.

> -c will be working in the newest kernels, but not yet in most distro
> kernels.

As another person replied, you meant in the 30-rc kernels? I can test
that, but the .29 kernels stopped working with the MTD devices on the
NAS cited above.

With .28 kernels, I can access all the partitions of the MTD devices,
which I can't with kernels .29 (that is, the .29 kernels lost
functionality).

I guess that I will reopen the bugzilla bug-report that I wrote before
and try the newer .30-rc kernels, then. Squeezing performance out of
this little machine is quite important in my case.

> The -d flag is not permitted by libata, as the kernel prefers to
> completely dictate DMA / PIO, and it does do a rather good job of it.

And what about corner cases like the ones that happen sometimes?

> The -m flag could be done, and I even have code in hdparm to do it,
> but libata is very buggy with multi-sector I/O, so -m is currently is
> disallowed.

I would be interested in putting in a new drive in the NAS and testing
your patch to debug things, if that would help with multi-sector I/O
getting fixed with libata.


Thanks,

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
