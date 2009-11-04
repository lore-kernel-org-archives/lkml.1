Return-Path: <linux-kernel-owner+w=401wt.eu-S932656AbZKDVSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656AbZKDVSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932635AbZKDVSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:18:15 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:47343 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbZKDVSO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:18:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=osJxMbfnVF1Qv1uokzVUEQiyQcBR5dOVg/KhKoYZ6pahy5E2FJZQ2n43uWsYMhXM7E
         LaWXH9wo0OB1xZJdyUsVpFQr0KjKV99gyGiDCwUAlaohfg6iBhOwduxuA+JUAnshQIol
         26fBKHZI+8OXkMO1bwObvPUWUQdEjNpUZvizk=
MIME-Version: 1.0
In-Reply-To: <1257291837-6246-3-git-send-email-vgoyal@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
	 <1257291837-6246-3-git-send-email-vgoyal@redhat.com>
Date: Wed, 4 Nov 2009 22:18:15 +0100
Message-ID: <4e5e476b0911041318w68bd774qf110d1abd7f946e4@mail.gmail.com>
Subject: Re: [PATCH 02/20] blkio: Change CFQ to use CFS like queue time stamps
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
On Wed, Nov 4, 2009 at 12:43 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> o Previously CFQ had one service tree where queues of all theree prio classes
>  were being queued. One side affect of this time stamping approach is that
>  now single tree approach might not work and we need to keep separate service
>  trees for three prio classes.
>
Single service tree is no longer true in cfq for-2.6.33.
Now we have a matrix of service trees, with first dimension being the
priority class, and second dimension being the workload type
(synchronous idle, synchronous no-idle, async).
You can have a look at the series: http://lkml.org/lkml/2009/10/26/482 .
It may have other interesting influences on your work, as the idle
introduced at the end of the synchronous no-idle tree, that provides
fairness also for seeky or high-think-time queues.

Corrado
