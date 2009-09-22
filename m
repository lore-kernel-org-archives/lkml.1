Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbZIVH5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbZIVH5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 03:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZIVH5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 03:57:52 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:50989 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbZIVH5v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 03:57:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LpFq81B023A4gie9qUclYq+SwAQUQ3Biw3okE2XERN5C8jGF1DC7hr4dN8pwPuVN7B
         eeym7CPxpiGPu03Ub2e/Lc0g6XCJ9UVj0ezgXbqfZyO53dqIqwmt2ohvJJljQGR4tIWR
         0NPdYDDHxcfC+PsJekcp3w40wY6I92eIt1FD8=
MIME-Version: 1.0
In-Reply-To: <4AB86A03.7060207@cn.fujitsu.com>
References: <c4e36d110909210307m6579807ehe4d659053c4dc696@mail.gmail.com>
	 <4AB86A03.7060207@cn.fujitsu.com>
Date: Tue, 22 Sep 2009 09:57:52 +0200
Message-ID: <c4e36d110909220057q6d9ce816yfcec7de4849c1969@mail.gmail.com>
Subject: Re: [PATCH] Add missing blk_trace_remove_sysfs to be in pair with 
	blk_trace_init_sysfs
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mbroz@redhat.com,
       tytso@mit.edu, jens.axboe@oracle.com, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/22 Li Zefan <lizf@cn.fujitsu.com>:
> Zdenek Kabelac wrote:
>> Subject: [PATCH] Add missing blk_trace_remove_sysfs to be in pair with
>> blk_trace_init_sysfs
>> From: Zdenek Kabelac <zkabelac@redhat.com>
>>
>> Adds missing blk_trace_remove_sysfs() to be in pair with
>> blk_trace_init_sysfs() introduced in commit
>> 1d54ad6da9192fed5dd3b60224d9f2dfea0dcd82.
>>
>> Problem was noticed via kmemleak backtrace when some sysfs entries
>> were note properly destroyed during  device removal:
>>
>
> Thanks for reporting and fixing this!
>
>> @@ -465,6 +466,7 @@ void blk_unregister_queue(struct gendisk *disk)
>>
>>               kobject_uevent(&q->kobj, KOBJ_REMOVE);
>>               kobject_del(&q->kobj);
>> +             blk_trace_remove_sysfs(disk_to_dev(disk));
>
> This should be moved outside of 'if'.
>

I was not really sure about the proper place - if it could be placed
before if() or after the if(){} - as I've not checked in depth
connection between kobj and sysfs. It's somewhat unclear why all the
kobject operation are only within this if(){} block - so I've thought
there is some reason...
IMHO only elv_unregister_queue() should be probably in the if(){} block.

Feel free to update/fix.

Zdenek
