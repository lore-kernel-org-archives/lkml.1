Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbXETR7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbXETR7I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 13:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756846AbXETR65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 13:58:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:37018 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833AbXETR64 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 13:58:56 -0400
To: =?iso-8859-1?q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>
Cc: tglx@linutronix.de, mingo@elte.hu, yi.zhu@intel.com,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       venkatesh.pallipadi@intel.com, trenn@suse.de
Subject: Re: Increased ipw2200 power usage with dynticks
References: <20070518154629.GA27105@atjola.homenet>
	<20070519171011.GA1995@atjola.homenet>
From: Andi Kleen <andi@firstfloor.org>
Date: 20 May 2007 20:55:35 +0200
In-Reply-To: <20070519171011.GA1995@atjola.homenet>
Message-ID: <p733b1re34o.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Björn Steinbrink <B.Steinbrink@gmx.de> writes:
> 
> Ok, it seems that ipw2200 is just a trigger for the problem here. AFAICT
> the cause of the worse C state usage is that after ipw2200 has woken the
> cpu, acpi_processor_idle() chooses C2 (due to dma? bm? I have no
> idea...) as the prefered sleep state. Now without NO_HZ or when I hold
> down a key, there are interrupts that wake up the CPU and when
> acpi_processor_idle() is called again the promotion to C3/C4 happens.
> But with NO_HZ, there are no such interrupts, most wakeups are caused by
> ipw2200 and so the processor doesn't go any deeper than C2 most of the
> time and thus wastes lots of power.

The cpuidle governour code Venki is working on is supposed to address this.
There have been also earlier prototype patches by Adam Belay and
Thomas Renninger.

-Andi
