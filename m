Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab0BWOCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 09:02:21 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:58744 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab0BWOCU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 09:02:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=QzU4JG3SpAfbZuBPM9S6zdsdqvfPcP7j5dWNXIe/71s/lhkGedfNXVf8w2wf3hQpq6
         dU80n0rX9hlk6IIbUEa1Kjhd2Gt206RuJ0KQz4QyoQpDtEoyKx4ydrgbmVMgVrv3bg0K
         LzoOAJZ2pVO5zHHDpbueGJABI/yNCxHg5rbtQ=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] failslab: add abitily to filter slab caches
References: <1266931960-9779-1-git-send-email-dmonakhov@openvz.org>
	<961aa3351002230558r6cc5846aq40d6ed21b7686ae7@mail.gmail.com>
Date: Tue, 23 Feb 2010 17:02:14 +0300
In-Reply-To: <961aa3351002230558r6cc5846aq40d6ed21b7686ae7@mail.gmail.com>
	(Akinobu Mita's message of "Tue, 23 Feb 2010 22:58:02 +0900")
Message-ID: <87mxz0vymx.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Akinobu Mita <akinobu.mita@gmail.com> writes:

> 2010/2/23 Dmitry Monakhov <dmonakhov@openvz.org>:
>> Example:
>> echo 1 > /sys/kernel/slab/skbuff_head_cache/failslab
>> echo 1 > /sys/kernel/debug/failslab/cache-filter
>
> Looks good.
>
> .Should we also support clearing the flag by
> "echo 0 > /sys/kernel/slab/skbuff_head_cache/failslab" ?
But it already does this, any output except "1" treated as '0'
I've snipped this from trace option.
>
>> +static ssize_t failslab_store(struct kmem_cache *s, const char *buf,
>> +                                                       size_t length)
>> +{
>> +       s->flags &= ~SLAB_FAILSLAB;
>> +       if (buf[0] == '1')
>> +               s->flags |= SLAB_FAILSLAB;
>> +       return length;
>> +}
>> +SLAB_ATTR(failslab);
