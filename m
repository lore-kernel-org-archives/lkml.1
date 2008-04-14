Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbYDNNs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbYDNNs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYDNNsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:48:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:42705 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbYDNNsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:48:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=EyTRiOaWXLXBGCIC2s4qNSZbbuGJC9BC8XUM335Qrff9MmAyaHBMhUtAtd6wtIKCpzVvuWvaRz4zBaeV0JXE6djC1A3Di+cFXs0ObZf76XC8zCj6B+AJ6GfA7bWxy3xNgahqfpd4ROsbG6SK+kuB+MQuayqQaRFuGS8FTRHj3z8=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Does process need to have a kernel-side stack all the time?
Date: Mon, 14 Apr 2008 15:47:57 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804141547.57719.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

You are one of the experts in processes/threads and scheduling
in Linux kernel, I hope you can answer this question.

A lot of effort went into minimizing of stack usage.
If I understand it correctly, one of the reasons for this
was to be efficient and not have lots of pages
used for stacks when we have a lot of threads
(tens of thousands).

A random thought occurred to me: in a system with so many
threads most of them are not executing anyway, even on
that gigantic Altix machines. Do they all need to have
kernel stack, all the time? I mean: the process which
is running in user space is not using kernel stack at all.
Process which is not running on a CPU right now
is not using it either. But they do still consume
at least 4k (or 8k on 64bits) of RAM.

Process absolutely must have kernel stack only when
it is actively running in kernel code (not sleeping),
right?

Can we have per-CPU kernel stacks instead, so that process
gets a kernel stack only every time it enters the kernel;
and make it so that the process which is scheduled away
from a CPU does not need to have kernel stack?

Currently, when process sleeps, we save some
state in stack, and such a change may require
some substantial surgery.

Can you tell me whether this is possible at all,
and how difficult you estimate it to be?
--
vda
