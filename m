Return-Path: <linux-kernel-owner+w=401wt.eu-S1759121AbZCYJfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121AbZCYJfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757976AbZCYJfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:35:05 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:13161 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755865AbZCYJfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:35:03 -0400
Message-ID: <49C9FABD.7000708@panasas.com>
Date: Wed, 25 Mar 2009 11:34:53 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org>
In-Reply-To: <49C93AB0.6070300@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2009 09:34:56.0561 (UTC) FILETIME=[F57DFA10:01C9AD2C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar. 24, 2009, 21:55 +0200, Jeff Garzik <jeff@garzik.org> wrote:
> Linus Torvalds wrote:
>> But I really don't understand filesystem people who think that "fsck" is 
>> the important part, regardless of whether the data is valid or not. That's 
>> just stupid and _obviously_ bogus.
> 
> I think I can understand that point of view, at least:
> 
> More customers complain about hours-long fsck times than they do about 
> silent data corruption of non-fsync'd files.
> 
> 
>> The point is, if you write your metadata earlier (say, every 5 sec) and 
>> the real data later (say, every 30 sec), you're actually MORE LIKELY to 
>> see corrupt files than if you try to write them together.
>>
>> And if you write your data _first_, you're never going to see corruption 
>> at all.
> 
> Amen.
> 
> And, personal filesystem pet peeve:  please encourage proper FLUSH CACHE 
> use to give users the data guarantees they deserve.  Linux's sync(2) and 
> fsync(2) (and fdatasync, etc.) should poke the block layer to guarantee 
> a media write.

I completely agree.  This also applies to nfsd_sync, by the way.
What's the right place to implement that?
How about sync_blockdev?

Benny

> 
> 	Jeff
> 
> 
> P.S.  Overall, I am thrilled that this ext3/ext4 transition and 
> associated slashdotting has spurred debate over filesystem data 
> guarantees.  This is the kind of discussion that has needed to happen 
> for years, IMO.
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Benny Halevy
Software Architect
Panasas, Inc.
bhalevy@panasas.com
Tel/Fax: +972-3-647-8340
Mobile: +972-54-802-8340

Panasas: The Leader in Parallel Storage
www.panasas.com
