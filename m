Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbZI2KWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbZI2KWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 06:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZI2KWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 06:22:40 -0400
Received: from mail-ew0-f227.google.com ([209.85.219.227]:65350 "EHLO
	mail-ew0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbZI2KWj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 06:22:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P0kLh7NEkMj+zaP36rfVOGYNuqUEqEmUEdA0nE+y4igNbRNacK0VO8RmW0PSNK/Ayg
         6CFlYw/hhiYi/BD3Y3KjRWQ4GpcgBvEO5gSsh2UBom0arC0dJDUbwXxCTytuLWZFvQOJ
         b+WQ0GHp64weEE0lEbn6goZCqLl9ZkUwflxsA=
MIME-Version: 1.0
In-Reply-To: <20090929074640.GA5233@nowhere>
References: <1251167570-5233-1-git-send-email-fweisbec@gmail.com>
	 <20090826201330.GA18761@orion> <20090914203749.GF6045@nowhere>
	 <a4423d670909141433g18659aay6e177b1302e5b4a0@mail.gmail.com>
	 <20090916203747.GB5068@nowhere>
	 <a4423d670909161637r67c933a0n2c142898ea493f22@mail.gmail.com>
	 <20090917050639.GA5060@nowhere>
	 <a4423d670909220655j37cc49f8rcd29d8f154c5e6e6@mail.gmail.com>
	 <20090929074640.GA5233@nowhere>
Date: Tue, 29 Sep 2009 14:22:42 +0400
Message-ID: <a4423d670909290322u4c1dd886tf55a2ea4a4a0977@mail.gmail.com>
Subject: Re: [PATCH] kill-the-bkl/reiserfs: Fix induced mm->mmap_sem to 
	sysfs_mutex dependency
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Reiserfs <reiserfs-devel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/29 Frederic Weisbecker <fweisbec@gmail.com>:
> On Tue, Sep 22, 2009 at 05:55:43PM +0400, Alexander Beregalov wrote:
>> Hi Frederic.
>>
>> Another very similar warning.
>> (smp 2*2core)
>> v2.6.31-7068-g43c1266 plus 193be0ee1 kill-the-bkl/reiserfs: Fix
>> induced mm->mmap_sem to sysfs_mutex dependency
>>
>>
>> [ INFO: possible circular locking dependency detected ]
>> 2.6.31-07095-g25a3912 #4
>> -------------------------------------------------------
>> udevadm/790 is trying to acquire lock:
>>  (&mm->mmap_sem){++++++}, at: [<c1098942>] might_fault+0x72/0xc0
>>
>> but task is already holding lock:
>>  (sysfs_mutex){+.+.+.}, at: [<c110813c>] sysfs_readdir+0x7c/0x260
>>
>> which lock already depends on the new lock.
>
>
>
> Yeah indeed, it's about the same kind of thing.
> Could you please test the following patch?

Thanks, the warning has gone away.
