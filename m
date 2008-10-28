Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYJ1Ocn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYJ1Ocn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 10:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYJ1OcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 10:32:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42546 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbYJ1OcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 10:32:23 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ian Kent <raven@themaw.net>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, autofs@linux.kernel.org
Subject: Re: [PATCH 4/6] autofs4 - make autofs type usage explicit
References: <20081023023513.4508.54940.stgit@raven.themaw.net>
	<20081023023532.4508.56823.stgit@raven.themaw.net>
	<20081027134050.c85a28dd.akpm@linux-foundation.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 28 Oct 2008 09:24:00 -0400
In-Reply-To: <20081027134050.c85a28dd.akpm@linux-foundation.org> (Andrew
	Morton's message of "Mon, 27 Oct 2008 13:40:50 -0700")
Message-ID: <x49tzaw6efj.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 23 Oct 2008 10:35:32 +0800
> Ian Kent <raven@themaw.net> wrote:
>
>> This patch further improves autofs mount type usage and provides
>> supplementry explanation of the changes made in the previous patch
>> "autofs4 - cleanup autofs mount type usage".
>> 
>> Changes introduced in "autofs4 - cleanup autofs mount type usage":
>> 
>> - the type assigned at mount when no type is given is changed
>>   from 0 to AUTOFS_TYPE_INDIRECT. This was done because 0 and
>>   AUTOFS_TYPE_INDIRECT were being treated implicitly as the same
>>   type.
>> 
>> - previously, an offset mount had it's type set to
>>   AUTOFS_TYPE_DIRECT|AUTOFS_TYPE_OFFSET but the mount control
>>   re-implementation needs to be able distinguish all three types.
>>   So this was changed to make the type setting explicit.
>> 
>> - a type AUTOFS_TYPE_ANY was added for use by the re-implementation
>>   when checking if a given path is a mountpoint. It's not really a
>>   type as we use this to ask if a given path is a mountpoint in the
>>   autofs_dev_ioctl_ismountpoint() function.
>> 
>> Changes introduced in this patch:
>> 
>> - macros to set and test the autofs mount types have been added to
>>   improve readability and make the type usage explicit.
>
>     ^^^^^^^^^^^^^^^^^^^  <<-- ??

Just for some background, I requested a change here.  The reason is that
I ran into problems in the user space daemon where there was this notion
of a bitfield that wasn't always treated as a bitfield.  So
AUTOFS_TYPE_ANY should be all bits set, right?  Nope.  Some places in
the code tested with binary operators, others with ==.  It was confusing
and error-prone.  The accessor functions at least normalize the interface.

Cheers,

Jeff
