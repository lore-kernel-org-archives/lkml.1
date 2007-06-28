Return-Path: <linux-kernel-owner+w=401wt.eu-S1764428AbXF1IJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764428AbXF1IJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 04:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761336AbXF1IJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 04:09:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33277 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178AbXF1IJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 04:09:09 -0400
Subject: Re: [PATCH] LinuxPPS (with new syscalls API)
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070627224623.GO13886@enneenne.com>
References: <20070626100628.GO24183@enneenne.com>
	 <1182855427.12109.203.camel@pmac.infradead.org>
	 <20070626170622.GA13886@enneenne.com>
	 <1182879520.3263.19.camel@shinybook.infradead.org>
	 <20070627101449.GH13886@enneenne.com>
	 <1182939510.6409.17.camel@pmac.infradead.org>
	 <20070627125802.GI13886@enneenne.com>
	 <1182960660.1170.12.camel@pmac.infradead.org>
	 <20070627174537.GM13886@enneenne.com>
	 <1182966588.1170.28.camel@pmac.infradead.org>
	 <20070627224623.GO13886@enneenne.com>
Content-Type: text/plain
Date: Thu, 28 Jun 2007 09:08:53 +0100
Message-Id: <1183018133.1170.46.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-28 at 00:46 +0200, Rodolfo Giometti wrote:
> Just last question: I still don't well understand where I should
> declare the new compat_sys_time_pps_fetch() syscall... it's
> automagically defined by the system when CONFIG_COMPAT is enabled? :-o

It isn't used on i386. On a 64-bit architecture, you need to put
compat_sys_time_pps_fetch() into the syscall table for 32-bit
processes. 

On PowerPC you do this by using COMPAT_SYS_SPU(time_pps_fetch) instead
of SYSCALL_SPU(..) in include/asm-powerpc/systbl.h. On x86_64 you'd put
it into the ia32_sys_call_table in arch/x86_64/ia32/ia32entry.S

-- 
dwmw2

