Return-Path: <linux-kernel-owner+w=401wt.eu-S932140AbZICQ54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbZICQ54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 12:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbZICQ54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 12:57:56 -0400
Received: from mail.lang.hm ([64.81.33.126]:56098 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009AbZICQ5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 12:57:55 -0400
Date: Thu, 3 Sep 2009 09:56:48 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Rob Landley <rob@landley.net>
cc: Pavel Machek <pavel@ucw.cz>, Ric Wheeler <rwheeler@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: what fsck can (and can't) do was Re: [patch] ext2/3: document
 conditions when reliable operation is possible
In-Reply-To: <200908291522.07694.rob@landley.net>
Message-ID: <alpine.DEB.2.00.0909030848480.28411@asgard.lang.hm>
References: <20090824212518.GF29763@elf.ucw.cz> <alpine.DEB.2.00.0908280748080.6822@asgard.lang.hm> <20090829100558.GH1634@ucw.cz> <200908291522.07694.rob@landley.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Aug 2009, Rob Landley wrote:

> On Saturday 29 August 2009 05:05:58 Pavel Machek wrote:
>> On Fri 2009-08-28 07:49:38, david@lang.hm wrote:
>>> On Thu, 27 Aug 2009, Rob Landley wrote:
>>>> Pavel's response was to attempt to document this.  Not that journaling
>>>> is _bad_, but that it doesn't protect against this class of problem.
>>>
>>> I don't think anyone is disagreeing with the statement that journaling
>>> doesn't protect against this class of problems, but Pavel's statements
>>> didn't say that. he stated that ext3 is more dangerous than ext2.
>>
>> Well, if you use 'common' fsck policy, ext3 _is_ more dangerous.
>
> The filesystem itself isn't more dangerous, but it may provide a false sense of
> security when used on storage devices it wasn't designed for.

from this discussin (and the similar discussion on lwn.net) there appears 
to be confusion/disagreement over what fsck does and what the results of 
not running it are.

it has been stated here that fsck cannot fix broken data, all it tries to 
do is to clean up metadata, but it would probably help to get a clear 
statement of what exactly that means.

I know that it:

finds entries that don't actually have data and deletes them

finds entries where multiple files share data blocks and duplicates the 
(bad for one file) data to seperate them

finds blocks that have been orphaned (allocated, but no directory pointer 
to them) and creates entries in lost+found

but if a fsck does not get run on a filesystem that has been damaged, what 
additional damage can be done?

can it overwrite data that could have been saved?

can it cause new files that are created (or new data written to existing, 
but uncorrupted files) to be lost?

or is it just a matter of not knowing about existing corruption?

David Lang

