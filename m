Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719AbXFXQ7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbXFXQ7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 12:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbXFXQ7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 12:59:12 -0400
Received: from lucidpixels.com ([75.144.35.66]:33299 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbXFXQ7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 12:59:10 -0400
Date: Sun, 24 Jun 2007 12:59:10 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Michael Tokarev <mjt@tls.msk.ru>
cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
       Jeff Garzik <jeff@garzik.org>, Carlo Wood <carlo@alinoe.com>,
       Tejun Heo <htejun@gmail.com>, Manoj Kasichainula <manoj@io.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: SATA RAID5 speed drop of 100 MB/s
In-Reply-To: <467E9356.1030200@msgid.tls.msk.ru>
Message-ID: <Pine.LNX.4.64.0706241257190.12207@p34.internal.lan>
References: <20070620224847.GA5488@alinoe.com> <4679B2DE.9090903@garzik.org>
 <20070622214859.GC6970@alinoe.com> <467CC5C5.6040201@garzik.org>
 <20070623125316.GB26672@alinoe.com> <467DA1F5.2060306@garzik.org>
 <467E5C5E.6000706@msgid.tls.msk.ru> <20070624125957.GA28067@gallifrey>
 <Pine.LNX.4.64.0706241021030.12207@p34.internal.lan> <467E9356.1030200@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 24 Jun 2007, Michael Tokarev wrote:

> Justin Piszcz wrote:
>> Don't forget about max_sectors_kb either (for all drives in the SW RAID5
>> array)
>>
>> max_sectors_kb = 8
>> $ dd if=/dev/zero of=file.out6 bs=1M count=10240
>> 10737418240 bytes (11 GB) copied, 55.4848 seconds, 194 MB/s
>>
>> max_sectors_kb = 128
>> 10737418240 bytes (11 GB) copied, 22.6298 seconds, 474 MB/s
>
> Well.  You're comparing something different.  Yes, this
> thread is about linux software raid5 in the first place,
> but I were commenting about [NT]CQ within a single drive.
>
> Overall, yes, the larger your reads/writes to the drive
> becomes, the faster its linear performance is.  Yet you
> have to consider real workload instead of very synthetic
> dd test.  It may be good approcsimation of a streaming
> video workload (when you feed a large video file over
> network or something like that), but even with this,
> you probably want to feed several files at once (different
> files to different clients), so single-threaded test
> here isn't very useful.  IMHO anyway, and good for a
> personal computer test.
>
> /mjt
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Concerning NCQ/no NCQ, without NCQ I get an additional 15-50MB/s in speed 
per various bonnie++ tests.

# Average of 3 runs with NCQ on for Quad Raptor 150 RAID 5 Software RAID:
p34-ncq-on,7952M,43916.3,96.6667,151943,28.6667,75794.3,18.6667,48991.3,99,181687,24,558.033,0.333333,16:100000:16/64,867.667,9,29972.7,98.3333,2801.67,16,890.667,9.33333,27743,94.3333,2115.33,15.6667
# Average of 3 runs with NCQ off for Quad Raptor 150 RAID 5 Software RAID:
p34-ncq-off,7952M,42470,97.3333,200409,36.3333,90240.3,22.6667,48656,99,198853,27,546.467,0,16:100000:16/64,972.333,10,21833,72.3333,3697,21,995,10.6667,27901.7,95.6667,2681,20.6667

