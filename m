Return-Path: <linux-kernel-owner+w=401wt.eu-S1759180AbYAYUqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180AbYAYUqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYAYUqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:46:36 -0500
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:48461
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYAYUqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:46:35 -0500
Date: Fri, 25 Jan 2008 13:57:50 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Andreas Dilger <adilger@sun.com>
cc: Al Boldi <a1426z@gawab.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
In-Reply-To: <20080125064739.GS18433@webber.adilger.int>
Message-ID: <alpine.DEB.1.00.0801251357010.6858@asgard.lang.hm>
References: <200801242336.00340.a1426z@gawab.com> <20080125064739.GS18433@webber.adilger.int>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2008, Andreas Dilger wrote:

> On Jan 24, 2008  23:36 +0300, Al Boldi wrote:
>> data=ordered mode has proven reliable over the years, and it does this by
>> ordering filedata flushes before metadata flushes.  But this sometimes
>> causes contention in the order of a 10x slowdown for certain apps, either
>> due to the misuse of fsync or due to inherent behaviour like db's, as well
>> as inherent starvation issues exposed by the data=ordered mode.
>>
>> data=writeback mode alleviates data=order mode slowdowns, but only works
>> per-mount and is too dangerous to run as a default mode.
>>
>> This RFC proposes to introduce a tunable which allows to disable fsync and
>> changes ordered into writeback writeout on a per-process basis like this:
>>
>>       echo 1 > /proc/`pidof process`/softsync
>
> If fsync performance is an issue for you, run the filesystem in data=journal
> mode, put the journal on a separate disk and make it big enough that you
> don't block on it to flush the data to the filesystem (but not so big that
> it is consuming all of your RAM).

my understanding is that the journal is limited to 128M or so. This 
prevents you from making it big enough to avoid all problems.

David Lang

> That keeps your data guarantees without hurting performance.
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
