Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbXFWHyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbXFWHyd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 03:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbXFWHyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 03:54:23 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:44096 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbXFWHyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 03:54:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=W32NqW/IGlT9TzUAUC5AU5jLTaRGxuyaUDXw6nNvKANWsnbAXGTYPAr98yBjXGxx70nlLfHy5p9HtXkalUp95DvWvug1GVO8xIjFhH9gSLZ6gbi7haHUiz3eA+XP7gvr4UtBcMGLm+3dhaa9EFWfIQmahx21Y4ToIg8lbw3WF1c=
Message-ID: <467CD1A8.5070700@gmail.com>
Date: Sat, 23 Jun 2007 16:54:16 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Carlo Wood <carlo@alinoe.com>, Manoj Kasichainula <manoj@io.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: SATA RAID5 speed drop of 100 MB/s
References: <20070620224847.GA5488@alinoe.com> <4679B2DE.9090903@garzik.org> <20070622214859.GC6970@alinoe.com> <467CC5C5.6040201@garzik.org>
In-Reply-To: <467CC5C5.6040201@garzik.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Carlo Wood wrote:
>> The dmesg output of 33480a0ede8dcc7e6483054279008f972bd56fd3 (thus
>> "before") is:
> [...]
>> And the dmesg output of 551c012d7eea3dc5ec063c7ff9c718d39e77634f (thus
>> "after") is:
> [...]
> 
> Your disk configurations are quite radically different between the two
> kernels (see attached diff for key highlights).
> 
> The new behavior of the more recent kernel (551c012d7...) is that it now
> fully drives your hardware :)  The reset problems go away, NCQ is
> enabled, and if you had 3.0Gbps drives (you don't) they would be driven
> at a faster speed.
> 
> Given that some drives might be better tuned for benchmarks in
> non-queued mode, and that a major behavior difference is that your
> drives are now NCQ-enabled, the first thing I would suggest you try is
> disabling NCQ:
>     http://linux-ata.org/faq.html#ncq
> 
> Other indicators are the other changes in the "ahci 0000:00:1f.2:
> flags:" line, which do affect other behaviors, though none so important
> to RAID5 performance as NCQ, I would think.
> 
> Turning on NCQ also potentially affects barrier behavior in RAID, though
> I'm guessing that is not a factor here.

Ah.. right.  That should have enabled NCQ.  Me slow today.  :-)

-- 
tejun
