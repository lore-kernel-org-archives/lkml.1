Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab0BWOIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 09:08:14 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:49092 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab0BWOIM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 09:08:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k0a4aRLm1yxD0o84a+xcf8IT2QBLWq2p5GsjZb2ze3xEJv71bXXbot/VxL38Cf24zi
         OVg99Fv729nwdTVqNxexN7xQ7mXJ1cQaZjok636pv6+CP6COdsZUfaacHcKz8kcNHaW1
         HSR17z8CuICx7tYprXaV/hfXXQyw5hEF2Cy4g=
MIME-Version: 1.0
In-Reply-To: <87mxz0vymx.fsf@openvz.org>
References: <1266931960-9779-1-git-send-email-dmonakhov@openvz.org>
	 <961aa3351002230558r6cc5846aq40d6ed21b7686ae7@mail.gmail.com>
	 <87mxz0vymx.fsf@openvz.org>
Date: Tue, 23 Feb 2010 23:08:07 +0900
Message-ID: <961aa3351002230608l5d5cbf88v41b3d645cfafccd5@mail.gmail.com>
Subject: Re: [PATCH] failslab: add abitily to filter slab caches
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/23 Dmitry Monakhov <dmonakhov@openvz.org>:
> Akinobu Mita <akinobu.mita@gmail.com> writes:
>
>> 2010/2/23 Dmitry Monakhov <dmonakhov@openvz.org>:
>>> Example:
>>> echo 1 > /sys/kernel/slab/skbuff_head_cache/failslab
>>> echo 1 > /sys/kernel/debug/failslab/cache-filter
>>
>> Looks good.
>>
>> .Should we also support clearing the flag by
>> "echo 0 > /sys/kernel/slab/skbuff_head_cache/failslab" ?
> But it already does this, any output except "1" treated as '0'
> I've snipped this from trace option.

Oops, you are right.

>>
>>> +static ssize_t failslab_store(struct kmem_cache *s, const char *buf,
>>> +                                                       size_t length)
>>> +{
>>> +       s->flags &= ~SLAB_FAILSLAB;
>>> +       if (buf[0] == '1')
>>> +               s->flags |= SLAB_FAILSLAB;
>>> +       return length;
>>> +}
>>> +SLAB_ATTR(failslab);
>
