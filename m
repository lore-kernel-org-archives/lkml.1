Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbZHTOm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbZHTOm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 10:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbZHTOm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 10:42:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730AbZHTOmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 10:42:53 -0400
Message-ID: <4A8D60C1.6000809@redhat.com>
Date: Thu, 20 Aug 2009 10:42:09 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com,
       linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: [PATCH, RFC] xfs: batched discard support
References: <20090816004705.GA7347@infradead.org> <20090819203916.GA25296@elte.hu> <4A8CA956.2060406@rtr.ca> <4A8D5442.1000302@redhat.com> <4A8D5FDB.7080505@rtr.ca>
In-Reply-To: <4A8D5FDB.7080505@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2009 10:38 AM, Mark Lord wrote:
> Ric Wheeler wrote:
>>
>> Note that returning consistent data is critical for devices that are
>> used in a RAID group since you will need each RAID block that is used
>> to compute the parity to continue to return the same data until you
>> overwrite it with new data :-)
>>
>> If we have a device that does not support this (or is misconfigured
>> not to do this), we should not use those devices in an MD group & do
>> discard against it...
> ..
>
> Well, that's a bit drastic. But the RAID software should at least
> not issue TRIM commands in ignorance of such.

If the storage can return different data in a sequence of READ requests of the 
same sector (with no writes), there is nothing RAID could do. It would see total 
garbage...

> Would it still be okay to do the TRIMs when the entire parity stripe
> (across all members) is being discarded? (As opposed to just partial
> data there being dropped)

This should be safe if the MD bitmaps would prevent us from trying to 
READ/regenerate parity for that stripe...

ric

