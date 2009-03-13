Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbZCMJRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbZCMJRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbZCMJRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:17:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:39344 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbZCMJRH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:17:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dMifB/WZXohAmsL57J4ms6peIJY4HB/Wt9G+YsJtbt82NXE90HUmogBIsVRjQX6lLD
         iJtY4SwJTxSEwA0fu/aXks+E+HvLyy70XXYmnoIPl9jRYbihdeDyBv0CeeesCQlJ8cux
         qCXo5K//oBHwydv/JeFP1q8B6WckMGqzirj+o=
MIME-Version: 1.0
In-Reply-To: <1236930985.5188.77.camel@laptop>
References: <20090311153034.9389.19938.stgit@warthog.procyon.org.uk>
	 <20090311170840.2f136849.akpm@linux-foundation.org>
	 <5DC5324CE00E4D4494EE5F031E354E9501CE9C0F@BUDMLVEM03.e2k.ad.ge.com>
	 <20090312112953.GD6995@shareable.org>
	 <1236858608.22914.3689.camel@twins>
	 <20090313082051.5eaa11a3.minchan.kim@barrios-desktop>
	 <1236930985.5188.77.camel@laptop>
Date: Fri, 13 Mar 2009 18:17:05 +0900
Message-ID: <28c262360903130217u4ebbc80ct6d857acd768f2eda@mail.gmail.com>
Subject: Re: [uClinux-dev] RE: [PATCH] NOMMU: Pages allocated to a ramfs 
	inode's pagecache may get wrongly discarded
From: Minchan Kim <minchan.kim@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jamie Lokier <jamie@shareable.org>,
       uClinux development list <uclinux-dev@uclinux.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 4:56 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2009-03-13 at 08:20 +0900, Minchan Kim wrote:
>
>> > > Does the vm pageout logic include or skip these "dirty" pages looking
>> > > for candidates to flush to storage?  What about with MMU?
>> >
>> > Includes them, regular pageout will try to do the writeout to clean them
>> > and then discard them.
>> >
>> > The ramfs stuff is rather icky in that it adds the pages to the aging
>> > list, marks them dirty, but does not provide a writeout method.
>> >
>> > This will make the paging code scan over them (continuously) trying to
>> > clean them, failing that (lack of writeout method) and putting them back
>> > on the list.
>>
>> It ins't true any more.
>> UNEVICTABLE_LRU will move ramfs's page from LRU to unevictable list.
>> Couldn't we solve this problem if NOMMU can support CONFIG_UNEVICTABLE_LRU ?
>
> That's more of a band-aid than a solution, no? They should never have
> been on the list to begin with.
>

I agree as Andrew pointed out.
It may be workaround but can be a good solution in current status.
And then, we have to improve it for removal of ramfs pages from lru
list in future, I think.

-- 
Kinds regards,
Minchan Kim
