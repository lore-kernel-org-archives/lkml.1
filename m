Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab0BJDMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 22:12:21 -0500
Received: from mail-qy0-f190.google.com ([209.85.221.190]:57240 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab0BJDMU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 22:12:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a6t7DpYOtxC+3nyE6fbBPQGGIhkTN9Msvgqf2L4mTLv/Kpmbk+xPKyivX5iFjLpI2v
         rP0TtuavRVMpIKwxsTqYcvr4DOHycTLxbSdInA/lAukEvCWF0p44ReKqJAJhiUmcVKjC
         ZP4Ga7vwa3zJSuAEf4UNxYO4nvvQHP+/4pUTw=
MIME-Version: 1.0
In-Reply-To: <4B7217CF.2080702@kernel.org>
References: <19314.1869.847327.15190@notabene.brown>
	 <2375c9f91002091808n713275dsc9ace8f51871364e@mail.gmail.com>
	 <4B7217CF.2080702@kernel.org>
Date: Wed, 10 Feb 2010 11:12:18 +0800
Message-ID: <2375c9f91002091912t52d8a1c6q1533ecfde5a5740e@mail.gmail.com>
Subject: Re: [PATCH] sysfs: differentiate between locking links and non-links
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Neil Brown <neilb@suse.de>, "Eric W ." <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 10:19 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 02/10/2010 11:08 AM, Américo Wang wrote:
>> This bug report is new for me. Recently we received lots of sysfs lockdep
>> warnings, I am working on a patch to fix all the bogus ones.
>>
>> However, this one is _not_ similar to the other cases, as you decribed.
>> This patch could fix the problem, but not a good fix, IMO. We need more
>> work in sysfs layer to fix this kind of things. I will take care of this.
>
> Can't we just give each s_active lock a separate class?  Would that be
> too costly?
>

Not because it is expensive or not, it is because whether it hits the real
problem.

What I am doing is trying to add a "mutable" flag to sysfs files, those files
could be removed from kernel during some changes, e.g. cpu hotplug, I/O
scheduler switch. I add a new lockdep class for all of them, so that will be
safe for all cases like this.

If I understand this case correctly, it is not that different with the
rest cases
that I met, thus should be included into my fix.

Thanks.
