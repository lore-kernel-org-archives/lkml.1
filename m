Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbZA0Xz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbZA0Xz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZA0Xzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:55:49 -0500
Received: from smtp-out.google.com ([216.239.45.13]:62143 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbZA0Xzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:55:48 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=G1ucLxptuIaKIrr/Re5bHQ3yl8JA4jCD8GpeVGsLAaQen9kRCC72wX0kDOTpuOtCD
	dDd+vGmDIZ/Ji7gqxa9IQ==
MIME-Version: 1.0
In-Reply-To: <20090122132133.GA17524@ioremap.net>
References: <200901211638.23101.knikanth@suse.de>
	 <200901212054.34929.knikanth@suse.de>
	 <alpine.DEB.2.00.0901211241040.21080@chino.kir.corp.google.com>
	 <200901221042.30957.knikanth@suse.de>
	 <alpine.DEB.2.00.0901220036440.28850@chino.kir.corp.google.com>
	 <20090122095026.GA10579@ioremap.net>
	 <alpine.DEB.2.00.0901220156310.1738@chino.kir.corp.google.com>
	 <20090122101424.GA12317@ioremap.net>
	 <alpine.DEB.2.00.0901220218120.2851@chino.kir.corp.google.com>
	 <20090122132133.GA17524@ioremap.net>
Date: Tue, 27 Jan 2009 15:55:38 -0800
Message-ID: <6599ad830901271555m7ba2ec0ercb0f0d046d71a48a@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
From: Paul Menage <menage@google.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: David Rientjes <rientjes@google.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.142
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 5:21 AM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> Having userspace to decide which task to kill may not work in some cases
> at all (when task is swapped and we need to kill someone to get the mem
> to swap out the task, which will make that decision).

That's true in the case of a global OOM. In the case of a local OOM
(caused by memory limits applied via the cgroup memory controller, or
NUMA affinity enforcement applied by cpusets) the userspace handler
can be in a different domain which isn't OOM, and be quite capable of
figuring out who to kill. In our particular use case, it can happen
that a high-priority job hits its memory limits and triggers an OOM,
which causes the system controller daemon to kill some lower-priority
job and reassign some memory from that now-dead low-priority job (and
thus prevent the OOM from killing any process in the original cgroup).
This is something that would be very hard to express via kernel
policy.

Paul
