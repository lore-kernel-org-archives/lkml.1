Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbYIXSdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbYIXSdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbYIXSdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:33:41 -0400
Received: from gw.goop.org ([64.81.55.164]:42040 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYIXSdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:33:40 -0400
Message-ID: <48DA8806.4060405@goop.org>
Date: Wed, 24 Sep 2008 11:33:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Should irq_chip->mask disable percpu interrupts to all cpus,
 or just to this cpu?
References: <48D94B64.3070004@goop.org> <20080924084558.GD5576@elte.hu> <m18wthna2f.fsf@frodo.ebiederm.org>
In-Reply-To: <m18wthna2f.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> I really hate the notion of sharing a single irq_desc across
> multiple cpus as a preferred mode of operation.  As NUMA comes
> into play it guarantees we will have cross cpu memory fetches
> on a fast path for irq handling.
>
> Other than the beautiful way we print things in /proc/interrupts
> IRQ_PER_CPU feels like a really bad idea.  Especially in that
> it enshrines the nasty per cpu irq counters that scale horribly.
>   

I found handle_percpu_irq() which addresses my concerns.  It doesn't
attempt to mask the interrupt, takes no locks, and doesn't set or test
IRQ_INPROGRESS in desc->status, so it will scale perfectly across
multiple cpus.  It makes no changes to the desc structure, so there
isn't even any cacheline bouncing.

    J
