Return-Path: <linux-kernel-owner+w=401wt.eu-S964937AbYHFP5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964937AbYHFP5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763876AbYHFP4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:56:23 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:45475 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763693AbYHFP4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:56:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Tam8L1LvNKvyX9BlX23/CEdPm+1aZuEPElaHlRqemMJ8NSXxozNSpGahECMhJ+QjBK
         LoQ6lMnoIdeK9RYJxrDIs2vWEqFlpAfCMhueYIfHdE52cNkFoU/KpoA2bNMb+6hpSRDY
         yYMn9JpX2IAGbgXOn7obce0qM4KCGNRLnnlBg=
Message-ID: <b647ffbd0808060856j33bb8ffey1cc32665bd88c071@mail.gmail.com>
Date: Wed, 6 Aug 2008 17:56:20 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [patch 3/5] [PATCH 3/5] x86: Run Intel ucode-updates via workqueue.
Cc: "Peter Oruba" <peter.oruba@amd.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Max Krasnyansky" <maxk@qualcomm.com>,
       "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080806084446.68683aaf@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080806152117.198754464@amd.com>
	 <20080806152319.773811325@amd.com>
	 <20080806084446.68683aaf@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/6 Arjan van de Ven <arjan@infradead.org>:
> On Wed, 6 Aug 2008 17:21:20 +0200
> Peter Oruba <peter.oruba@amd.com> wrote:
>
> [ no description or reason ]
>
> Why is this?

More details are available here.

I've also suggested to do ucode-updates as early as possible  from
start_secondary() (or whatever low-level code).

The second patch (do via workqueue) was just a proof-of-concept (to
show that it does fix a crash).

>
> I'm not very happy about this.. it means practically that this stuff
> *has* to run late. Probably later than we want to.

Currently, it runs from cpu-hotplug-notifier(CPU_ONLINE, ...)
[ and crashes with .26+ due to a reason you may find via the
aforementioned link ] - by this moment, at least kernel threads may
running on this cpu -- so it's not that early.

> (Like.. we may want to redo the microcode during resume.. which is
> not a schedulable context)

I'm not sure what's "schedulable context" here terms but the existing
code makes use of set_cpus_allowed_ptr() which means a caller expects
to be able to be migrated onto a target cpu and do ucode-update while
running on it.

Moreover, the way set_cpus_allowed_ptr() is used there seems to be
race wrt. sched_setaffinity().


-- 
Best regards,
Dmitry Adamushko
