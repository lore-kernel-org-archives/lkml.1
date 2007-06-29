Return-Path: <linux-kernel-owner+w=401wt.eu-S932928AbXF2MjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928AbXF2MjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758332AbXF2MjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:39:17 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:58393 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753058AbXF2MjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:39:16 -0400
Date: Fri, 29 Jun 2007 14:39:09 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       Kyle McMartin <kyle@parisc-linux.org>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] generic bug: use show_regs() instead of dump_stack()
Message-ID: <20070629143909.763925e5@dhcp-255-175.norway.atmel.com>
In-Reply-To: <20070629121959.GA16581@osiris.boeblingen.de.ibm.com>
References: <20070629121959.GA16581@osiris.boeblingen.de.ibm.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007 14:19:59 +0200
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> [patch] generic bug: use show_regs() instead of dump_stack()
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> The current generic bug implementation has a call to dump_stack() in
> case a WARN_ON(whatever) gets hit. Since report_bug(), which calls
> dump_stack(), gets called from an exception handler we can do better:
> just pass the pt_regs structure to report_bug() and pass it to
> show_regs() in case of a warning. This will give more debug informations
> like register contents, etc... In addition this avoids some pointless
> lines that dump_stack() emits, since it includes a stack backtrace of
> the exception handler which is of no interest in case of a warning.
> E.g. on s390 the following lines are currently always present in a stack
> backtrace if dump_stack() gets called from report_bug():
> 
>  [<000000000001517a>] show_trace+0x92/0xe8)
>  [<0000000000015270>] show_stack+0xa0/0xd0
>  [<00000000000152ce>] dump_stack+0x2e/0x3c
>  [<0000000000195450>] report_bug+0x98/0xf8
>  [<0000000000016cc8>] illegal_op+0x1fc/0x21c
>  [<00000000000227d6>] sysc_return+0x0/0x10

I've seen those extra lines on avr32 as well and I agree they are
confusing. Register contents is nice to have too.

Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
