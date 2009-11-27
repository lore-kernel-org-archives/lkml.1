Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbZK0DCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbZK0DCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 22:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbZK0DCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 22:02:08 -0500
Received: from mail-qy0-f192.google.com ([209.85.221.192]:49291 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbZK0DCH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 22:02:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EmFcG6HI+LN6lVWtzxbUEIovOLEVTvWHUfPp4SVb3HBdCZxfw6zU0Wo+wMHbgsCp4Q
         FC36PW8C6yjntNeyrGZM7+Bj5GALuP0tW08SYfhxH7QJz29+O7WKth+uUovSo/fyP0RW
         fYg0LvMOCWm6Tg3263yCHxy2wuPF5rlTBppGI=
MIME-Version: 1.0
In-Reply-To: <20091127025512.GB5406@nowhere>
References: <20091127022820.GU32182@kryten>
	 <2375c9f90911261846i18a828eft391420b13bb3fbb2@mail.gmail.com>
	 <20091127025512.GB5406@nowhere>
Date: Fri, 27 Nov 2009 11:02:13 +0800
Message-ID: <2375c9f90911261902q1f7df666nc0b303e89d88d643@mail.gmail.com>
Subject: Re: PATCH: softlockup: Fix hung_task_check_count sysctl
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Anton Blanchard <anton@samba.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, msb@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 10:55 AM, Frederic Weisbecker
<fweisbec@gmail.com> wrote:
> On Fri, Nov 27, 2009 at 10:46:53AM +0800, Américo Wang wrote:
>> On Fri, Nov 27, 2009 at 10:28 AM, Anton Blanchard <anton@samba.org> wrote:
>> >
>> > I'm seeing spikes of up to 0.5ms in khungtaskd on a large machine. To reduce
>> > this source of jitter I tried setting hung_task_check_count to 0:
>> >
>> > # echo 0 > /proc/sys/kernel/hung_task_check_count
>> >
>> > which didn't have the intended response. Change to a post increment of
>> > max_count, so a value of 0 means check 0 tasks.
>> >
>> > Signed-off-by: Anton Blanchard <anton@samba.org>
>>
>>
>> Ack.
>>
>> I would also suggest to make 'max_count' as unsigned long,
>> since sysctl_hung_task_check_count is.
>>
>> Thanks.
>
>
> Also, the batch_count thing should be dropped I think.
> This is a hardcoded, not overridable pause after 1024
> threads checks to avoid latencies caused by rcu_read_lock.
> But now we have PREEMPT_RCU so people can enable it if
> they care about latency. We should remove it as it adds
> unnecessary complexity.

This sounds OK for me.

>
> I'm preparing a patch for that, on top of Anton patch.
>

Great!

Thanks.
