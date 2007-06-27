Return-Path: <linux-kernel-owner+w=401wt.eu-S1757896AbXF0Hrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbXF0Hrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 03:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbXF0Hre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 03:47:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38408 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbXF0Hrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 03:47:33 -0400
Message-ID: <46821613.9010305@garzik.org>
Date: Wed, 27 Jun 2007 03:47:31 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
References: <20070627073526.GA18787@havoc.gtf.org> <20070627003841.68fd0ea9.akpm@linux-foundation.org>
In-Reply-To: <20070627003841.68fd0ea9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 27 Jun 2007 03:35:26 -0400 Jeff Garzik <jeff@garzik.org> wrote:
> 
>> +	/* Don't allow DMA if it isn't multiple of 16 bytes.  Quite a
>> +	 * few ATAPI devices choke on such DMA requests.
>> +	 */
>> +	if (unlikely(qc->nbytes & 15))
>> +		return 1;
> 
> It might be worth emitting a diagnostic when this happens.

I tend to disagree, but if any screaming users show up, we can certainly 
think about adding some.

Such would be a diagnostic that would trigger on valid SCSI commands, 
when the user is doing nothing wrong and the system can indeed complete 
the command just fine.  Additionally, this is moving us in the direction 
of what the IDE driver has apparently been doing.

	Jeff


