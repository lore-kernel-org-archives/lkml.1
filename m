Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbZJFMLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbZJFMLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 08:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbZJFMLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 08:11:13 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:61928 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379AbZJFMLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 08:11:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=UHp3uDlS6VmjYjrVoiVVaoO9CTymfXvDxpf8GXvBmKfDjfKdGQ2bkmq/s3/TehQ43c
         SkP2MzR2OG1Mo1y+/dX0jxjEOLNBO3d5+HR6+PyMPFx7DEL+k/lWfLV+C7CAU0eZ58V5
         6CYQ5UAYLMzykMCfAyuKFlvZ4YXIYdAC9coCs=
MIME-Version: 1.0
In-Reply-To: <20091006103300.GI9832@redhat.com>
References: <20091006190938.126F.A69D9226@jp.fujitsu.com>
	 <20091006102136.GH9832@redhat.com>
	 <20091006192454.1272.A69D9226@jp.fujitsu.com>
	 <20091006103300.GI9832@redhat.com>
Date: Tue, 6 Oct 2009 21:10:35 +0900
X-Google-Sender-Auth: 164a295e4de139d3
Message-ID: <2f11576a0910060510y401c1d5ax6f17135478d22899@mail.gmail.com>
Subject: Re: [PATCH][RFC] add MAP_UNLOCKED mmap flag
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/6 Gleb Natapov <gleb@redhat.com>:
> On Tue, Oct 06, 2009 at 07:27:56PM +0900, KOSAKI Motohiro wrote:
>> > On Tue, Oct 06, 2009 at 07:11:06PM +0900, KOSAKI Motohiro wrote:
>> > > Hi
>> > >
>> > > > If application does mlockall(MCL_FUTURE) it is no longer possible to
>> > > > mmap file bigger than main memory or allocate big area of anonymous
>> > > > memory. Sometimes it is desirable to lock everything related to program
>> > > > execution into memory, but still be able to mmap big file or allocate
>> > > > huge amount of memory and allow OS to swap them on demand. MAP_UNLOCKED
>> > > > allows to do that.
>> > > >
>> > > > Signed-off-by: Gleb Natapov <gleb@redhat.com>
>> > >
>> > > Why don't you use explicit munlock()?
>> > Because mmap will fail before I'll have a chance to run munlock on it.
>> > Actually when I run my process inside memory limited container host dies
>> > (I suppose trashing, but haven't checked).
>> >
>> > > Plus, Can you please elabrate which workload nedd this feature?
>> > >
>> > I wanted to run kvm with qemu process locked in memory, but guest memory
>> > unlocked. And guest memory is bigger then host memory in the case I am
>> > testing. I found out that it is impossible currently.
>>
>> 1. process creation (qemu)
>> 2. load all library
> Can't control this if program has plugging. Not qemu case
> though.
>
>> 3. mlockall(MCL_CURRENT)
>> 4. load guest OS
> And what about all other allocations qemu does during its life time? Not
> all of them will be small enough to be from brk area.
>
>> is impossible? why?
>>
> Because what you are proposing is not the same as mlockall(MCL_CURRENT|MCL_FUTURE);
>
> You essentially say that MCL_FUTURE is not needed.

No, I only think your case doesn't fit MC_FUTURE.
I haven't find any real benefit in this patch.
