Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab0BJDd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 22:33:56 -0500
Received: from mail-qy0-f190.google.com ([209.85.221.190]:44662 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab0BJDdz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 22:33:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SY7MN/UBCsO9dwL/gvSYlP1+Tic1fAQkZ8q8FU1UFaIFU07dDFS3uYEWMeZdKb3jGV
         Ti26G5Il2II0dBFqHPyFOg66V+LcDDbNd4IsJ8cCi8eFHeWZ/yTuFZ2hY9RfPnge504O
         xloDFqF3L1XPeRjK9ArfQRXLwZb1CGJPBPPkw=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1002091917230.31159@chino.kir.corp.google.com>
References: <19314.1869.847327.15190@notabene.brown>
	 <alpine.DEB.2.00.1002091716580.13999@chino.kir.corp.google.com>
	 <2375c9f91002091756h132e81eava8575ffd4e3ad421@mail.gmail.com>
	 <alpine.DEB.2.00.1002091858180.31159@chino.kir.corp.google.com>
	 <2375c9f91002091914l6738a06eq5cba5f5fbf08976a@mail.gmail.com>
	 <alpine.DEB.2.00.1002091917230.31159@chino.kir.corp.google.com>
Date: Wed, 10 Feb 2010 11:33:53 +0800
Message-ID: <2375c9f91002091933t3add9e19ydb62b85c61718f95@mail.gmail.com>
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

On Wed, Feb 10, 2010 at 11:19 AM, David Rientjes <rientjes@google.com> wrote:
> On Wed, 10 Feb 2010, Américo Wang wrote:
>
>> > You should be able to reuse Neil's sysfs_dirent_init_lockdep(sd, type) to
>> > seperate the lock classes for the sd getting pinned in
>> > sysfs_get_active_two() from sysfs_deactivate(), although using subclasses
>> > would probably be optimal since there is a clear parent -> child relationship.
>>
>> Yeah, basically, my fix is also adding a separate lockdep class, but
>> at a different
>> level. I will send the fix as soon as I finish it.
>>
>
> They shouldn't be entirely seperate classes for your "mutable" cases since
> there will always be a parent -> child relationship, they should be
> subclasses under the same lockclass at a SINGLE_DEPTH_NESTING level.

The relationship is not always clear, take the cpu hotplug case as an example,
there are plenty of sysfs files will be removed if we take one cpu
offline, like mce
files, which are not even under the same directory with cpu sysfs
device directory.
