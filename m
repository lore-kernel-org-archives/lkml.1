Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbZBVNdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbZBVNdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 08:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbZBVNdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 08:33:10 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:64891 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbZBVNdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 08:33:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HRi56ImuP90t8Z5/obT32nx0ZNJht7qK+LnWDXKqjobBXu0ywpZGh9Z/bTTIstAbWo
         7iUm3FdHXOBQav1JleOXdpNDq6I6zUkAS/ulATk797h+X7TUMiG2OOw3Ydjbz7O6zWmh
         VHLAfsjCjOMbj4ukrAtG8yz2aRSjtgNCjWmjo=
MIME-Version: 1.0
In-Reply-To: <20090221152251.GA6807@nowhere>
References: <b9df5fa10902131936p5e0997c6p57f659457a9cc356@mail.gmail.com>
	 <20090221152251.GA6807@nowhere>
Date: Sun, 22 Feb 2009 19:33:08 +0600
Message-ID: <b9df5fa10902220533rb625291k135b3218151e12e5@mail.gmail.com>
Subject: Re: [PATCH -mm] tracing: Fix section mismatch in trace_hw_branches.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, markus.t.metzger@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/09, Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi,
>
>  When I saw this patch, I searched the real purpose of __cpuinit and its
>  real impact.
>  But I didn't find any comments about it inside the kernel.
>
>  But today, by looking at the discussion around latest git pull for x86
>  to mainline, I discover that __cpuinit becomes __init on UP.
>
>  So, unless I missed something, this patch seems to me very dangerous.
>  The init and reset callbacks of a tracer can be called at any time, not only
>  on initcalls time (__init functions are freed from memory after the middle stage
>  of the boot).
>  With this patch, on UP we will dereference freed memory while activating this tracer.
If the init and reset callbacks of a tracer can be called regardless
of cpu hotpluging then it is. If the tracer's init or reset doesn't
rely on cpuhotplug then it shouldn't use it.
There's a another way to fix the warning is by remove __cpuinitdata
from bts_hotcpu_notifier.

Thanks,
