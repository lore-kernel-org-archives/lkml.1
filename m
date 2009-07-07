Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbZGGWIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbZGGWIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 18:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755695AbZGGWID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 18:08:03 -0400
Received: from mail.tmr.com ([64.65.253.246]:59056 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072AbZGGWIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 18:08:00 -0400
Message-ID: <4A53C6FD.3010603@tmr.com>
Date: Tue, 07 Jul 2009 18:06:53 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 pango-text SeaMonkey/1.1.16
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Mike Snitzer <snitzer@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out
  of the 'queue' sysfs directory.
References: <19010.62951.886231.96622@notabene.brown>	<yq11vp8spxo.fsf@sermon.lab.mkp.net>	<125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>	<yq1k530qkm7.fsf@sermon.lab.mkp.net>	<19012.47077.328965.919868@notabene.brown>	<yq1ws6znja4.fsf@sermon.lab.mkp.net> <19026.43290.340555.774690@notabene.brown>
In-Reply-To: <19026.43290.340555.774690@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Friday June 26, martin.petersen@oracle.com wrote:
>   
>> As far as making the application of these values more obvious I propose
>> the following:
>>
>> What:		/sys/block/<disk>/queue/minimum_io_size
>> Date:		April 2009
>> Contact:	Martin K. Petersen <martin.petersen@oracle.com>
>> Description:
>> 		Storage devices may report a granularity or minimum I/O
>> 		size which is the device's preferred unit of I/O.
>> 		Requests smaller than this may incur a significant
>> 		performance penalty.
>>
>> 		For disk drives this value corresponds to the physical
>> 		block size. For RAID devices it is usually the stripe
>> 		chunk size.
>>     
>
> These two paragraphs are contradictory.  There is no sense in which a
> RAID chunk size is a preferred minimum I/O size.
>
> To some degree it is actually a 'maximum' preferred size for random
> IO.  If you do random IO is blocks larger than the chunk size then you
> risk causing more 'head contention' (at least with RAID0 - with RAID5
> the tradeoff is more complex).
>
>   
Actually this is allocation unit, and the array can be assumed to be a 
series of sets of contiguous bytes of this size. Given LBA addressing, 
array members which are not simple whole devices, etc, this doesn't 
(can't) promise much for the physical layout. And any read which resides 
entirely within a chunk would not have a performance penalty, although 
write might, if it were not a multiple of the sector size of the array 
member(s) involved.

> If you are talking about "alignment", then yes - the chunk size is an
> appropriate size to align on.  But so are the block size and the
> stripe size and none is, in general, any better than any other.
>
>   
I would assume that a chunk, aligned on a chunk boundary, would be 
allocated in a contiguous series of bytes on the underlying array 
member. And that any i/o not aligned on a chunk boundary would be more 
likely to access multiple array members.

Feel free to clarify my assumptions.

> Also, you say "may" report.  If a device does not report, what happens
> to this file.  Is it not present, or empty, or contain a special
> "undefined" value?
> I think the answer is that "512" is reported.  It might be good to
> explicitly document that.
>   
> I'd really like to see an example of how you expect filesystems to use
> this.
> I can well imagine the VM or elevator using this to assemble IO
> requests in to properly aligned requests.  But I cannot imagine how
> e.g mkfs would use it.
> Or am I misunderstanding and this is for programs that use O_DIRECT on
> the block device so they can optimise their request stream?
>   

-- 
Bill Davidsen <davidsen@tmr.com>
  Obscure bug of 2004: BASH BUFFER OVERFLOW - if bash is being run by a
normal user and is setuid root, with the "vi" line edit mode selected,
and the character set is "big5," an off-by-one error occurs during
wildcard (glob) expansion.

