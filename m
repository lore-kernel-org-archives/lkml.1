Return-Path: <linux-kernel-owner+w=401wt.eu-S1757630AbYLFAck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbYLFAck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 19:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYLFAcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 19:32:33 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:40245 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbYLFAcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 19:32:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=l7mv49JrHpmCtl/Oaazq5SpBbSttCkIQ9GElJ47UgPj6YyoJuTbXYB/LJ+cmI/vk8K
         BIgIQqEZtQQ1p0pQ0sucAWci7hITs1RBkma6I6pJQd0U5/p/3f/Cnfvvc9kTQ/fiHuBJ
         RP+c7sqmiPTVq0WgcyRRMrx4B5rjJySIQh018=
Message-ID: <208aa0f00812051632h38fc0a5g58d233190436cc90@mail.gmail.com>
Date: Fri, 5 Dec 2008 16:32:30 -0800
From: "Edward Estabrook" <edward.estabrook.lkml@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
Cc: "Peter Zijlstra" <peterz@infradead.org>, edward_estabrook@agilent.com,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       edward.estabrook@gmail.com, hugh <hugh@veritas.com>,
       linux-mm <linux-mm@kvack.org>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20081205094447.GA3081@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43FC624C55D8C746A914570B66D642610367F29B@cos-us-mb03.cos.agilent.com>
	 <1228379942.5092.14.camel@twins> <20081204180809.GB3079@local>
	 <1228461060.18899.8.camel@twins> <20081205094447.GA3081@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, UIO already rapes the mmap interface by using the "offset" parameter to
> pass in the number of the mapping.

Exactly.

> But I'll NAK the current concept, too. It's a UIO kernel driver's task to tell
> userspace which memory a device has to offer. The UIO core prevents userspace
> as much as possible from mapping anything different. And it should stay that
> way.

The ultimate purpose (I thought) of the UIO driver is to simplify
driver development
by pushing device control into userspace.  There is a very real need
for efficient
dynamic control over the DMA allocation of a device.  Why not 'allow' this to
happen in userspace if it can be done safely and without breaking anything else?

Remember that for devices employing ring buffers it is not a question of
'how much memory a device has to offer' but rather 'how much system
memory would the
driver like to configure that device to use'.

I don't want to stop my DMA engine and reload the driver to create
more buffers (and I don't
want to pre-allocate more than I need as contingency).

Cheers,
Ed
