Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbZHPO0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbZHPO0G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 10:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbZHPO0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 10:26:05 -0400
Received: from rtr.ca ([76.10.145.34]:41554 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220AbZHPO0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 10:26:04 -0400
Message-ID: <4A8816FB.8070408@rtr.ca>
Date: Sun, 16 Aug 2009 10:26:03 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH, RFC] xfs: batched discard support
References: <20090816004705.GA7347@infradead.org> <4A876255.10606@rtr.ca> <4A876CA9.20906@rtr.ca> <20090816022500.GA12392@infradead.org> <4A8802F3.6010908@rtr.ca> <4A8810C4.3050800@rtr.ca> <20090816142331.GA4284@infradead.org>
In-Reply-To: <20090816142331.GA4284@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Sun, Aug 16, 2009 at 09:59:32AM -0400, Mark Lord wrote:
>> Okay, I got Matthews patches updated onto 2.6.31, and fixed the incompatibilities
>> between those and the XFS TRIM patch (from Christoph), plus a sector_t printk issue.
>>
>> My apologies for attachments, but I am attaching the updated Christoph patch,
>> as well as my hacked-up forward-port of Matthew's patches.
>>
>> Not pretty, but they work.  :)
>>
>> Now.. running Christoph's "xfs trim" on a 4.6GB mostly already-trimmed
>> XFS partition gave this for the first time around:
> 
>> The problem is, it still issues TRIMs to the LLD one extent at a time.
>> Compare this with doing it all in a single TRIM command
>> with the wiper.sh script (filesystem unmounted):
> 
> I could do a variant which issues a single TRIM, but that would require
> us to lock out all other allocations for the time the trim takes.  I'll
> hack that up once I get some time.
..

Matthew's stuff will have to change to support that, too.
