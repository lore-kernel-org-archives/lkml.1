Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbYIIQjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbYIIQjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbYIIQjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:39:24 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:53445 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049AbYIIQjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:39:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=F+mXM4VyARJmFflk64kgbGiHwD+mEszkvzdDT3ImyqggqGZeoEJA/eZwjKS4vyYcVq
         b//l1FtPb83tNiNeahsozcOQnt1/eNim+m4B4tXPrCetz/MFfbzNODq+FzPfSmSUChLY
         J2sS0/AHKfpW/AtGvUKdFFaYEFfMBKkOrHmvs=
Message-ID: <48C6A6B0.8090606@gmail.com>
Date: Tue, 09 Sep 2008 18:39:12 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: kamezawa.hiroyu@jp.fujitsu.com
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Carl Henrik Lunde <chlunde@ping.uio.no>,
       Divyesh Shah <dpshah@google.com>, Naveen Gupta <ngupta@google.com>,
       Fernando Luis V?zquez Cao <fernando@oss.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Marco Innocenti <m.innocenti@cineca.it>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Vivek Goyal <vgoyal@redhat.com>,
       Matt Heaton <matt@bluehost.com>, David Radford <dradford@bluehost.com>,
       containers@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC] [PATCH -mm] cgroup: limit the amount of dirty file pages
References: <48C6987D.2050905@gmail.com> <11118085.1220977593430.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <11118085.1220977593430.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kamezawa.hiroyu@jp.fujitsu.com wrote:
> ----- Original Message -----
>> This is a totally experimental patch against 2.6.27-rc5-mm1.
>>
>> It allows to control how much dirty file pages a cgroup can have at any
>> given time. This feature is supposed to be strictly connected to a
>> generic cgroup IO controller (see below).
>>
>> Interface: a new entry "filedirty" is added to the file memory.stat,
>> reporting the number of dirty file pages (in pages), and a new file
>> memory.file_dirty_limit_in_pages is added in the cgroup filesystem to
>> show/set the current limit.
>>
> Before staring patch review, why not dirty_ratio per memcg ?
> Is there difficult implementation issue ?

mmmh.. maybe it's a bit more complex (would add some overhead?) to
translate the limit from dirty_ratio into pages or bytes, because we
need to evaluate it in function of the per-cgroup dirtyable memory (lru
pages and free pages I suppose). Maybe it's enough to implement it
directly in determine_dirtyable_memory().

I can try to implement it and post a new patch.

-Andrea
