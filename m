Return-Path: <linux-kernel-owner+w=401wt.eu-S1765880AbZDHN52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765880AbZDHN52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765714AbZDHN5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:57:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:65001 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbZDHN5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:57:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=mDka+sEXkmg4PHTa9YifPDbk/D0LKHOfjtn2qsrZOTp4eaMHgIpFUdBmV1WuQAGyr0
         yyr7/5s8LwIhtunjzN2Z6RauNNuyasEy/y3KuxWD6IbW9Z9U5tTMAccwqfAmi61+GsAL
         8M3Mu3PccPsZTNE+Had5hX8bqlJ+NkhuD+y94=
Date: Wed, 8 Apr 2009 17:57:05 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH -tip] x86: do_IRQ - send EOI for x86-32 on irq without
	handler
Message-ID: <20090408135705.GA7556@lenovo>
References: <20090403185729.GC12273@localhost> <20090408130217.GL18581@elte.hu> <20090408132558.GA1141@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090408132558.GA1141@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Wed, Apr 08, 2009 at 03:25:58PM +0200]
| 
| * Ingo Molnar <mingo@elte.hu> wrote:
| 
| > 
| > * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
| > 
| > > For X86-32 if IRQ has no handler it remains non-Ack'ed
| > > even if APIC is not requested for being disabled.
| > > Fix it.
| > 
| > nice fix. Did you observe any real hangs in such a situation, or is 
| > this via code review?

Code review

| 
| more stuff needs fixing here first:
| 
| arch/x86/kernel/irq.c: In function ‘do_IRQ’:
| arch/x86/kernel/irq.c:226: error: ‘disable_apic’ undeclared (first use in this function)
| arch/x86/kernel/irq.c:226: error: (Each undeclared identifier is reported only once
| arch/x86/kernel/irq.c:226: error: for each function it appears in.)
| 
| like making 'disable_apic' available everywhere.
| 
| Or better yet: introduce a dummy apic->write() method in the 
| disable_apic=1 case so we can call a straight ack_APIC_irq().
| 
| 	Ingo
| 

Ugh! Thanks Ingo! Will check and fix!

        Cyrill
