Return-Path: <linux-kernel-owner+w=401wt.eu-S1751494AbZJTKnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbZJTKnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 06:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbZJTKnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 06:43:17 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:55094 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbZJTKnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 06:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NKOOq9K2wMVvv2c7uImuOc+xk5ZVMIchZ4sOOCBS0SOIxXPX59uM51M8WeRR90UorD
         7LAK+reTPjCdRv0awkZ7QpdrrsvyTswZURE49za8TjokPBf5n/CXvzFC0jT2ThuMeTCA
         EJfCLHdh4jmB+qRIh7k5U/8bRWAHxhEFuvSM8=
MIME-Version: 1.0
In-Reply-To: <20091020005813.GD10727@kernel.dk>
References: <200910192221.23564.czoccolo@gmail.com>
	 <20091020005813.GD10727@kernel.dk>
Date: Tue, 20 Oct 2009 12:43:20 +0200
Message-ID: <4e5e476b0910200343s1d7913daq5719d8a4d84fb491@mail.gmail.com>
Subject: Re: [RFC PATCH 3/5] cfq-iosched: reimplement priorities using 
	different service trees
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 2:58 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, Oct 19 2009, Corrado Zoccolo wrote:
>> We use different service trees for different priority classes.
>> This allows a simplification in the service tree insertion code, that no
>> longer has to consider priority while walking the tree.
>
>> +enum wl_prio_t {
>> +     IDLE_WL = -1,
>> +     BE_WL = 0,
>> +     RT_WL = 1
>> +};
>
> WL?
It stands for "workload". When defining all-caps constants, one has to
avoid possible clashes adding pre/suf-fixes.
Any suggestion for better naming?
>
>> +static struct cfq_rb_root *service_tree_for(enum wl_prio_t prio,
>> +                                     struct cfq_data *cfqd)
>> +{
>> +     return prio == IDLE_WL ? &cfqd->service_tree_idle :
>> +             &cfqd->service_trees[prio];
>> +}
>
> Don't do it...
>
> static struct cfq_rb_root *service_tree_for(enum wl_prio_t prio,
>                                        struct cfq_data *cfqd)
> {
>        if (prio == IDLE_WL)
>                return &cfqd->service_tree_idle;
>
>        return &cfqd->service_trees[prio];
> }
>
> much cleaner. There are more of these in this patch.
I don't see much difference: my brain just translates the former in
the latter, and the former takes up less screen space.
But you are the maintainer, so I'll write it as you want.

> Otherwise it looks sane, and I agree that making the insert cleaner here
> is a good bonus.

Thanks
Corrado
>
> --
> Jens Axboe
>
>
