Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZCaEX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZCaEX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 00:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbZCaEXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 00:23:44 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:57564 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZCaEXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 00:23:43 -0400
Message-ID: <49D19ACC.5040608@oss.ntt.co.jp>
Date: Tue, 31 Mar 2009 13:23:40 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Chris Mason <chris.mason@oracle.com>, Eric Sandeen <sandeen@redhat.com>,
       Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix blkdev_issue_flush() failure handling
References: <200903291928.14451.bzolnier@gmail.com> <1238413667.30488.2.camel@think.oraclecorp.com> <49D0C29C.1060307@uvigo.es> <200903301726.12548.bzolnier@gmail.com>
In-Reply-To: <200903301726.12548.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> On Monday 30 March 2009, Fernando Luis Vázquez Cao wrote:
>> Chris Mason wrote:
>>> On Sun, 2009-03-29 at 22:22 -0500, Eric Sandeen wrote:
>>>> Theodore Tso wrote:
>>>>> On Sun, Mar 29, 2009 at 12:43:22PM -0500, Eric Sandeen wrote:
>>>>>> As long as we keep the call there this is probably good, but after
>>>>>> talking w/ Chris Mason, I think the call is extraneous anyway and should
>>>>>> probably just be removed...
>>>>>>
>>>>> Yes, I agree, but it takes a lot of digging to be completely sure of
>>>>> that it's safe to remove it.  Interestingly, it was you who added the
>>>>> patch which added the call to blkdev_issue_flush():
>>>>> commit d755fb384250d6bd7fd18a0930e71965acc8e72e
>>>>> Author: Eric Sandeen <sandeen@redhat.com>
>>>>> Date:   Fri Jul 11 19:27:31 2008 -0400
>>>> Yes, it was.  Although I got the idea when hch pointed out that SuSE did
>>>> this... thanks to Chris.  It's come full circle.  :)
>>> Grin.  I'm not sure the I_DIRTY checks alone are enough to decide that a
>>> commit is required though.  I think the inode could be clean but still
>>> have metadata that needs commit.
>> Chris, I have just sent patches that attempt to fix both ext3 and
>> ext4 while also adding a per-device sysfs knob tu disable
>> write-flushes. A previous version of this patch set added a new
>> generic mount option but comments from Christoph and others
>> convinced me to turn it into a per-device tunable. Could you take
>> a look at the patches?
>>
>> Bartlomiej, I have just noticed that I happened to be working on
>> patches for reiserfs and xfs similar to the ones you sent earlier
>> this week. I picked some bits from your submission so I took the
>> liberty to add your signed-off to my patches. Could you take a
>> look at them and let me know if you are confortable with that?
> 
> I'm fine with people building bigger changes on top of my patches
> but if you do so you please clearly denote in the patch description
> what changes you have applied to the original patch...

You are right, sorry about that. I will add a short changelog when I
resubmit the patches.

Thanks!

- Fernando
