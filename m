Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbZHTRTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbZHTRTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 13:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbZHTRTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 13:19:21 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:59668 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbZHTRTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 13:19:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=n6BbcESG+x8XpOu/POE7M+C2SvVo24/WEwFhAxI1saig5Jp6GDxIWOTIsv2+Pmduyp
         Y1oulDh0j8QlkHuKcLzizmeKOcsvEZVsD3m0HJUkmTPuauf5E+DUcXwFzAw7FWDc7/9+
         Zc7h3oAa3Ov5hXMHXw7+Ogt1bHXoHFRHfhdmI=
MIME-Version: 1.0
In-Reply-To: <4A8D60C1.6000809@redhat.com>
References: <20090816004705.GA7347@infradead.org>
	 <20090819203916.GA25296@elte.hu> <4A8CA956.2060406@rtr.ca>
	 <4A8D5442.1000302@redhat.com> <4A8D5FDB.7080505@rtr.ca>
	 <4A8D60C1.6000809@redhat.com>
Date: Thu, 20 Aug 2009 13:19:20 -0400
Message-ID: <87f94c370908201019i406e74a0s59c67f56ec2c9c16@mail.gmail.com>
Subject: Re: [PATCH, RFC] xfs: batched discard support
From: Greg Freemyer <greg.freemyer@gmail.com>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Mark Lord <liml@rtr.ca>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com,
       linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 10:42 AM, Ric Wheeler<rwheeler@redhat.com> wrote:
> On 08/20/2009 10:38 AM, Mark Lord wrote:
>>
>> Ric Wheeler wrote:
>>>
>>> Note that returning consistent data is critical for devices that are
>>> used in a RAID group since you will need each RAID block that is used
>>> to compute the parity to continue to return the same data until you
>>> overwrite it with new data :-)
>>>
>>> If we have a device that does not support this (or is misconfigured
>>> not to do this), we should not use those devices in an MD group & do
>>> discard against it...
>>
>> ..
>>
>> Well, that's a bit drastic. But the RAID software should at least
>> not issue TRIM commands in ignorance of such.
>
> If the storage can return different data in a sequence of READ requests of
> the same sector (with no writes), there is nothing RAID could do. It would
> see total garbage...
>
>> Would it still be okay to do the TRIMs when the entire parity stripe
>> (across all members) is being discarded? (As opposed to just partial
>> data there being dropped)
>
> This should be safe if the MD bitmaps would prevent us from trying to
> READ/regenerate parity for that stripe...
>
> ric

The harder thing for mdraid is putting a stripe back in service.  If
even a single sector is written to a "discarded" stripe, the entire
stripe has to be written with determinate data that has the right
parity.

ie. Only full stripes can be discarded and only full-stripes can be
put back in service.

Greg
-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
Preservation and Forensic processing of Exchange Repositories White Paper -
<http://www.norcrossgroup.com/forms/whitepapers/tng_whitepaper_fpe.html>

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
