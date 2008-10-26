Return-Path: <linux-kernel-owner+w=401wt.eu-S1752586AbYJZHEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbYJZHEB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 03:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbYJZHDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 03:03:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:32747 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYJZHDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 03:03:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ETtYZR158BJLyRnPhzByZHZlIPEFPyGWeQv4670Z0P3/0B07Bp4wIcCC3JX+h/GRvD
         EGfbp3xRYpSN/eMqvcpuki2twNE1lQnlDbIJevfsXX/ymjw2EpGFIznpeZhJePbz+lrd
         mgCJk1nEpuHTV9cRd5TNoT3VlZMEKyHy00Pf8=
Message-ID: <4904164F.5090006@gmail.com>
Date: Sun, 26 Oct 2008 09:03:43 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
CC: mingo@elte.hu, srostedt@redhat.com, a.p.zijlstra@chello.nl,
       sandmann@daimi.au.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Add support for userspace stacktraces in tracing/iter_ctrl
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>	 <1223817124-27239-3-git-send-email-edwintorok@gmail.com> <c62985530810252105k3bce2339k5a49c09fa502ac67@mail.gmail.com>
In-Reply-To: <c62985530810252105k3bce2339k5a49c09fa502ac67@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-10-26 06:05, Frédéric Weisbecker wrote:
> Hi Török,
>
> I just read a bit more those two patches about user stack tracing.
> Note that despite the recent changes on the tracing Api
> (ring buffer and other stuff), it still applies well, with some little
> hunks. But it needs some updates to support the last changes.
>
> I adapted the patch and it builds well, but I didn't tested yet.
> However, some parts are "architecture dependent", I guess these
> special pieces would find a better place in the arch directory. So it
> would let a proper and seperated implementation.
>   

Hi,

The stacktrace code itself is in the arch directory, did I miss anything
else that should belong there?

arch/x86/kernel/stacktrace.c |   57 +++++++++++++++++++++++++++++++++++
include/linux/stacktrace.h   |    8 +++++


> And most arch implement a stacktrace implementation, even if yours
> involve special operations such as copy_from_user, I wonder if the
> already established code couldn't be reused for your needs.
>   

I think it would make sense to use oprofile's code of user stacktracing,
there  is a backtrace
operation in 'struct oprofile_operations'. Perhaps that could be
extended so that non-oprofile code can call it?
[currently it uses oprofile_add_trace to store the stacktrace]

Best regards,
--Edwin
