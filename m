Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbZJXUIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbZJXUIo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 16:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbZJXUIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 16:08:44 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:60722 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbZJXUIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 16:08:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VS9ZEO6OrofAIkBSS3r8ROUZ10DE83UtJy3tJ0wgNhCj5I6UoYnSC67E7I4+qPGxg4
         uZUn//9XzTRuK09LBZ2NfbBYLGn32XU7bfCmGaJHUTnCExWVzJMIquo0YrThtMD9jwwj
         m3NWOQIaHXTScojHVe8IEnuGjzLOXLgzt09m0=
MIME-Version: 1.0
In-Reply-To: <1256332492-24566-1-git-send-email-jmoyer@redhat.com>
References: <1256332492-24566-1-git-send-email-jmoyer@redhat.com>
Date: Sat, 24 Oct 2009 22:08:48 +0200
Message-ID: <4e5e476b0910241308s4a14fb69jbc6f8d35eb0ab78@mail.gmail.com>
Subject: Re: [PATCH/RFC 0/4] cfq: implement merging and breaking up of 
	cfq_queues
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,
this series looks good.
I like in particular the fact that you move seekiness detection in the cfqq.
This can help with processes that issue sequential reads and seeky
writes, or vice versa.
Probably, also the think time could be made per-cfqq, so that the
decision whether we should idle for a given cfqq is more precise.

On Fri, Oct 23, 2009 at 11:14 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Hi,
>
> This is a follow-up patch to the original close cooperator support for
> CFQ.  The problem is that some programs (NFSd, dump(8), iscsi target
> mode driver, qemu) interleave sequential I/Os between multiple threads
> or processes.  The result is that there are large delays due to CFQ's
> idling logic that leads to very low throughput.

You identified the problem in the idling logic, that reduces the
throughput in this particular scenario, in which various threads or
processes issue (in random order) the I/O requests with different I/O
contexts on behalf of a single entity.
In this case, any idling between those threads is detrimental.
Ideally, such cases should be already spotted, since think time should
be high for such processes, so I wonder if this indicates a problem in
the current think time logic.
Can you send me your read-test, so I can investigate it?

Thanks,
Corrado
