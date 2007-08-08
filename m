Return-Path: <linux-kernel-owner+w=401wt.eu-S1758316AbXHHPzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316AbXHHPzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 11:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbXHHPzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 11:55:00 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59452 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbXHHPy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 11:54:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <teheo@suse.de>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, satyam@infradead.org,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 0/25] Sysfs cleanups & tagged directory support
References: <11860582832964-git-send-email-htejun@gmail.com>
	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>
	<20070808093815.0935a18e@gondolin.boeblingen.de.ibm.com>
	<m1bqdifowo.fsf@ebiederm.dsl.xmission.com>
	<20070808095432.4a520735@gondolin.boeblingen.de.ibm.com>
	<m17io6foh8.fsf@ebiederm.dsl.xmission.com>
	<20070808103759.0850383c@gondolin.boeblingen.de.ibm.com>
	<20070808161631.1ccf27fd@gondolin.boeblingen.de.ibm.com>
	<46B9D4B8.4050201@gmail.com>
	<20070808165027.29af40b5@gondolin.boeblingen.de.ibm.com>
	<46B9D961.4000902@gmail.com>
	<m1r6medpxl.fsf@ebiederm.dsl.xmission.com>
	<46B9DDA1.1080704@gmail.com> <46B9DE5E.7050406@suse.de>
Date: Wed, 08 Aug 2007 09:53:38 -0600
In-Reply-To: <46B9DE5E.7050406@suse.de> (Tejun Heo's message of "Thu, 09 Aug
	2007 00:16:46 +0900")
Message-ID: <m11weednul.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <teheo@suse.de> writes:

> Tejun Heo wrote:
>> Eric W. Biederman wrote:
>>> Tejun Heo <htejun@gmail.com> writes:
>>>
>>>> Cornelia Huck wrote:
>>>>> On Wed, 08 Aug 2007 23:35:36 +0900,
>>>>> Tejun Heo <htejun@gmail.com> wrote:
>>>>>
>>>>>> Does the attached patch happen to fix the problem?
>>>>> Indeed it does; thanks!
>>>> Yeah, you seem to have 32bit off_t.  UINT_MAX overflows, so...
>>> Weird.  And we have it opening the directory O_LARGEFILE.
>>>
>>> I have no problems with the fix though.
>> 
>> It's probably because of struct dirent definition used by readdir().
>
> More specifically, d_off field.  It's a bit twisted.  For the last
> entry, filp->f_pos gets written into the field and gets wrapped while
> being copied out to userland or in glibc.

That could do it, and glibc is crunching it.  Oh well, it is
easy enough to avoid as long as our inode numbers are small which
the idr allocator seems to ensure.

Eric
