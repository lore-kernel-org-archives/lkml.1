Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924Ab0ATEyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab0ATEyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 23:54:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785Ab0ATEyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 23:54:01 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:42572 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab0ATEyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 23:54:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fR1fPBpvPa3TGQuJ8A04QOFTb/M3kNTUIxWRW5c2AyDdjmqQUT4lz5mHb8JAbyWho+
         uXVly6vGpNT8GEZvejFxSU5f7IU/TpzV/nqpOPdnxj4fGB08up+rS0s0yjDe9MyM5oUO
         i1ToqKAvc3vpryx9KnuAb5ddAF6M0gZNYgrCc=
Message-ID: <4B568C63.4050506@gmail.com>
Date: Tue, 19 Jan 2010 22:53:55 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Bart Hartgers <bart.hartgers@gmail.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       juergen.metzdorf@telelev-dsl.de, markpschool@hotmail.com,
       sporadic.crash@gmail.com, apopov@sirma.bg, david@coomber.co.za,
       jay4mail@gmail.com
Subject: Re: [patch 2/2] sata_via: Delay on vt6420 when starting ATAPI DMA
   write
References: <20100116235653.898098245@gmail.com> <20100116235851.884756038@gmail.com> <4B5678E2.2050709@gmail.com>
In-Reply-To: <4B5678E2.2050709@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2010 09:30 PM, Tejun Heo wrote:
> Hello,
>
> On 01/17/2010 08:56 AM, Bart Hartgers wrote:
>> When writing a disc on certain lite-on dvd-writers (also rebadged as
>> optiarc/LG/...) connected to a vt6420, the ATAPI CDB ends up in the
>> datastream and on the disc, causing silent corruption.  Delaying
>> between sending the CDB and starting DMA seems to prevent this.
>>
>> I do not know if there are burners that do not suffer from this, but
>> the patch should be safe for those as well.
>>
>> There are many reports of this issue, but AFAICT no solution was
>> found before. For example:
>> http://lkml.indiana.edu/hypermail/linux/kernel/0802.3/0561.html
>>
>> Signed-off-by: Bart Hartgers<bart.hartgers@gmail.com>
>
> Ah... you found solution for this?  That's great.  This is one of the
> three problems that have been lingering for years - the other two
> being pata_ali ATAPI DMA problem and sata_sil data corruption problem.
> I'll be ecstatic if this fix works.  Just one thing, I don't think
> we'll need a warning message there.  It's useful during development
> but it doesn't really provide any useful information afterwards.

Another tiny nitpick about the patch, the unlikely() around the 
DMA_TO_DEVICE check probably shouldn't be there - unlikely() is for 
things that will always be either highly unlikely or a slow path, 
neither of which really apply.

>
> Digging up the mailing list and cc'ing people who have reported this
> problem.  If you still have the affected systems, can you guys please
> test the patch in the following message and see whether it fixes the
> problem?
>
>    http://article.gmane.org/gmane.linux.kernel/939112/raw
>
> Thanks a lot.  :-)
>

