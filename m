Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbYGSCMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbYGSCMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 22:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYGSCMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 22:12:32 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:20784 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbYGSCM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 22:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=AnH6nWf4N28KdZg5tFvPFn1whenefUxGwnlTTFmTpY9R8oqvGvKq4FyCQ9lYcmWuDF
         ho5z9EF0T4MfEksOBbImahsW6eX27W4Cd4VTV4EMCoBpo26W7q0TthFoxf6LjSEBr+Ei
         flZ3yih2hNYTK4VWh5gUKmCUOLCrYvHMcC4lM=
Message-ID: <48814D81.8060001@gmail.com>
Date: Sat, 19 Jul 2008 11:12:17 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       scsi <linux-scsi@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Takashi Iwai <tiwai@suse.de>, tino.keitel@gmx.de
Subject: Re: linux-next: Tree for July 16 (crash on quad core AMD)
References: <20080716235011.ac9643aa.sfr@canb.auug.org.au>	<200807170053.36661.rjw@sisk.pl>	<1216249292.3358.66.camel@localhost.localdomain>	<200807170109.30655.rjw@sisk.pl>	<48808EE0.2060603@gmail.com>	<20080719004736.626ef169@mjolnir.drzeus.cx>	<48813C5F.70007@gmail.com> <20080719033050.552f9b49@mjolnir.drzeus.cx>
In-Reply-To: <20080719033050.552f9b49@mjolnir.drzeus.cx>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
>> Well, I don't know how often such usages would be necessary.  If it's a
>> very common ops, you can add a param to the next function but frankly I
>> think it's better to build a inside control structure for that.  There's
>> no need for external buffer, just an inner loop is sufficient.
>>
> 
> I'm not sure how this can be solved by an inner loop. My primary use
> case is:
> 
> 1. Wait for interrupt
> 2. Write n bytes
> 3. goto 1
> 
> n has no guarantee of being aligned to any page boundaries, so state
> needs to be kept between each invokation of writing a chunk of data. I
> doubt I'm alone in this use pattern (in fact, most device drivers using
> PIO should do something similar).

Oh... I see.  How about adding sg_miter_consume(@miter, @bytes)?  If the
function is never called, the whole chunk is assumed to be consumed.  If
the function is called only @bytes are consumed.

-- 
tejun
