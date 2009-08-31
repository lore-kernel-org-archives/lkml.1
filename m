Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbZHaPqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbZHaPqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 11:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbZHaPqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 11:46:21 -0400
Received: from mail.lang.hm ([64.81.33.126]:48142 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbZHaPqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 11:46:20 -0400
Date: Mon, 31 Aug 2009 08:45:38 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@ucw.cz>
cc: George Spelvin <linux@horizon.com>, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
In-Reply-To: <20090831105645.GD1353@ucw.cz>
Message-ID: <alpine.DEB.2.00.0908310844230.6822@asgard.lang.hm>
References: <20090831005426.13607.qmail@science.horizon.com> <20090831105645.GD1353@ucw.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Aug 2009, Pavel Machek wrote:

>> Actually, there is something the file system can do to make journaling
>> safe on degraded RAIDs: make the (checksummed) journal blocks equal to
>> the RAID stripe size.  Or, equivalently, pad out to the RAID stripe
>> size each commit.
>>
>> This sometimes leads to awkward block sizes, but while writing
>> to any *one* stripe on a degraded RAID-5 endangers the others, you
>> can write to *all* of them with the usual semantics.
>
> Well, that would work... but you'd also have to journal data, with the
> same block size. Not exactly fast, but at least safe...
>
>> That's one thing I really like about ZFS: its policy of "don't trust
>> the disks."  If nothing else, simply telling you "your disks f*ed up,
>> and I caught them doing it", instead of the usual mysterious corruption
>> detectec three months later, is tremendoudly useful information.
>
> The more I learn about storage, the more I like idea of zfs. Given the
> subtle issues between filesystem and raid layer, integrating them just
> makes sense.

note that all that zfs does is tell you that you already lost data (and 
then only if the checksumming algorithm would be invalid on a blank block 
being returned), it doesn't protect your data.

David Lang
