Return-Path: <linux-kernel-owner+w=401wt.eu-S932103AbXF2M1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbXF2M1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761205AbXF2M1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:27:33 -0400
Received: from gw.goop.org ([64.81.55.164]:37612 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757658AbXF2M1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:27:32 -0400
Message-ID: <4684FA7A.4030001@goop.org>
Date: Fri, 29 Jun 2007 08:26:34 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, Andi Kleen <ak@suse.de>,
       Kyle McMartin <kyle@parisc-linux.org>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] generic bug: use show_regs() instead of dump_stack()
References: <20070629121959.GA16581@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20070629121959.GA16581@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
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

Yep, seems reasonable to me.

Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>

    J
