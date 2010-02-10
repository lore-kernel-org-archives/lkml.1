Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab0BJDOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 22:14:16 -0500
Received: from mail-qy0-f190.google.com ([209.85.221.190]:35495 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab0BJDOO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 22:14:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=phC67hUyCN4njOzFQSJqukiFI6PRSJEofdKBEDGVgmHekEBpgENK/TyYlU1UEoJpDe
         dJRzHWKz0WtVzTI6DaqVLDAGMWmb7A81zBxS1cP3W0PhjlvD15jYINHr98p1hMKrz2AP
         hO7Nof2wzWADbH1FOtSNFh4fQqJShzei0UUIk=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1002091858180.31159@chino.kir.corp.google.com>
References: <19314.1869.847327.15190@notabene.brown>
	 <alpine.DEB.2.00.1002091716580.13999@chino.kir.corp.google.com>
	 <2375c9f91002091756h132e81eava8575ffd4e3ad421@mail.gmail.com>
	 <alpine.DEB.2.00.1002091858180.31159@chino.kir.corp.google.com>
Date: Wed, 10 Feb 2010 11:14:13 +0800
Message-ID: <2375c9f91002091914l6738a06eq5cba5f5fbf08976a@mail.gmail.com>
Subject: Re: [PATCH] sysfs: differentiate between locking links and non-links
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Neil Brown <neilb@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 11:05 AM, David Rientjes <rientjes@google.com> wrote:
> On Wed, 10 Feb 2010, Américo Wang wrote:
>
>> > What happens for hard links such as writing to
>> > /sys/devices/block/xxx/queue/scheduler to change an I/O scheduler which
>> > requires sd->dep_map and sd->parent->dep_map in sysfs_get_active_two() to
>> > pin both?  The call to kobject_del() invokes the destruction that also
>> > requires sd->dep_map in sysfs_deactivate() because of the s_active lockdep
>> > annotation.
>> >
>>
>> This is not related with Neil's case at all.
>>
>> The I/O scheduler switch case should be a bogus, I am working on
>> it. We have more similar cases of cpu hotplug. Trust me, I am working
>> on a fix to all of them, this is not as easy as you may think about.
>>
>
> You should be able to reuse Neil's sysfs_dirent_init_lockdep(sd, type) to
> seperate the lock classes for the sd getting pinned in
> sysfs_get_active_two() from sysfs_deactivate(), although using subclasses
> would probably be optimal since there is a clear parent -> child relationship.

Yeah, basically, my fix is also adding a separate lockdep class, but
at a different
level. I will send the fix as soon as I finish it.

Thanks.
