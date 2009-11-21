Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbZKUTVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbZKUTVy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 14:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbZKUTVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 14:21:53 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:41075 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546AbZKUTVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 14:21:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=JeRxMUkre60A5wlTQJ9lERybEIuDOmpCI7U6uWRCbpJpkOn4Guv3tEYpR+I6aByJ5s
         FyJyWRYd5vzdQrkVfJr2Jhko8cZtkEQKlyif4TOrp4+ArW/KBAx3mSbKgk/X348KAc03
         FOTTfpr9ol5d9rs49OVm/GO7/L5MYNoxxs/b0=
MIME-Version: 1.0
In-Reply-To: <20091121170355.7540d169@mjolnir.ossman.eu>
References: <20091008163952.679572b5@mjolnir.ossman.eu>
	 <20091121170355.7540d169@mjolnir.ossman.eu>
Date: Sat, 21 Nov 2009 12:21:58 -0700
X-Google-Sender-Auth: e6b509825e193566
Message-ID: <e9c3a7c20911211121l517837f9s17283dd37e0dd865@mail.gmail.com>
Subject: Re: Raid not shutting down when disks are lost?
From: Dan Williams <dan.j.williams@intel.com>
To: Pierre Ossman <pierre-list@ossman.eu>
Cc: neilb@suse.de, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 21, 2009 at 9:03 AM, Pierre Ossman <pierre-list@ossman.eu> wrote:
> Neil?
>
> On Thu, 8 Oct 2009 16:39:52 +0200
> Pierre Ossman <pierre-list@ossman.eu> wrote:
>
>> Today one RAID6 array I manage decided to lose four out of eight disks.
>> Oddly enough, the array did not shut down but instead I got
>> intermittent read and writer errors from the filesystem.

This is expected.

The array can't shutdown when there is a mounted filesystem.  Reads
may still be serviced from the survivors, all writes should be aborted
with an error.

>>
>> It's been some time since I had a failure of this magnitude, but I seem
>> to recall that once the array lost too many disks, it would shut down
>> and refuse to write a single byte. The nice effect of this was that if
>> it was a temporary error, you could just reboot and the array would
>> start nicely (albeit in degraded mode).
>>
>> Has something changed? Is this perhaps an effect of using RAID6 (I used
>> to run RAID5 arrays)? Or was I simply lucky the previous instances I've
>> had?

It should not come back up nicely in this scenario.  You need
"--force" to attempt to reassemble a failed array.

>>
>> Related, it would be nice if you could control how it handles lost
>> disks. E.g. I'd like it to go read-only when it goes in to fully
>> degraded mode. In case the last disk lost was only a temporary glitch,
>> the array could be made to recover without a lengthy resync.
>>

When you say "fully-degraded" do you mean "failed"?  In general the
bitmap mechanism provides fast resync after temporary disk outages.

--
Dan
