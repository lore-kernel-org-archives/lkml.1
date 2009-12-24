Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbZLXPI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbZLXPI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 10:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbZLXPI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 10:08:28 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52427 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbZLXPI1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 10:08:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=savqJRw9X6oy/adAbYaf6tlQ4gS8tuBaxn9CYaYTnNI27JD/6MtnZAVniL5ngryWUs
         lWEmHMkoCT98Xhq7c7wD7jbBTIKmBICGF09hBgN+bbfsj7frh0gpYJO2byIPUajeMDP0
         cBipSERgSJPhlS6MeWa9SSfd+PLXpZXZQICC8=
MIME-Version: 1.0
In-Reply-To: <7fc616880912240426q249c72b1n45d488fe0e6a9770@mail.gmail.com>
References: <b2f3590f0912231358g798049ey2c8012ff02a956da@mail.gmail.com>
	 <7fc616880912240426q249c72b1n45d488fe0e6a9770@mail.gmail.com>
Date: Thu, 24 Dec 2009 10:08:23 -0500
Message-ID: <b2f3590f0912240708p659dee0ap744bb39a0a480644@mail.gmail.com>
Subject: Re: libsas - sas_queue's policy of re-queuing all the tasks ...
From: Chetan Loke <chetanloke@gmail.com>
To: =?UTF-8?B?546L6YeR5rWm?= <jinpuwang@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 24, 2009 at 7:26 AM, 王金浦 <jinpuwang@gmail.com> wrote:
>
>
> 2009/12/24 Chetan Loke <chetanloke@gmail.com>
>>
>> Hello,
>>
>> I've a question regarding the libsas core.
>>
>> So, sas_queue() will dispatch the coalesced tasks. It then invokes the
>> SAS_LLDD's execute_task. Let's assume mv_sas driver.In this case
>> mvs_task_exec(). Say, it received 'N' tasks the first time it was
>> called.However, the LLDD was only able to service M tasks(where M<N).
>> Now it will return rc(non-zero value). sas_queue will then requeue all
>> the tasks. But only (N-M) tasks should have been queued, correct? So
>> why are we re-trying all the tasks again?
>>
>
> if you see the code , at mv_init , in function mvs_post_sas_ha_init set
> sha->lldd_max_execute_num = 1;
> and libsas invoke sas_queue_up when sha->lldd_max_execute_num> 1 .
>

Ignore the max_execute_num for this discussion. What I'm saying is, if
you do 'coalesce' the tasks.
mv_sas core clearly has 256+ slots in their adapter. That means you
could coalesce them. Well, that's not the point.
What I would like to know is why does the libsas core wants to requeue
all the tasks?
What was the rationale behind this logic?

> Jack Wang
>

Chetan Loke
