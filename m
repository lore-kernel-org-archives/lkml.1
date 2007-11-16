Return-Path: <linux-kernel-owner+w=401wt.eu-S932805AbXKPDmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbXKPDmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 22:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758412AbXKPDma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 22:42:30 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36246 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331AbXKPDm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 22:42:29 -0500
Date: Thu, 15 Nov 2007 19:41:16 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: x86: disable preemption in delay_tsc()
Message-ID: <20071115194116.12c7a0f6@laptopd505.fenrus.org>
In-Reply-To: <200711150400.lAF40lIr020160@hera.kernel.org>
References: <200711150400.lAF40lIr020160@hera.kernel.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 04:00:47 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:
> http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=35d5d08a085c56f153458c3f5d8ce24123617faf
> Commit:     35d5d08a085c56f153458c3f5d8ce24123617faf Parent:
> 7eea436433b7b18045f272562e256976f593f7c0 Author:     Andrew Morton
> <akpm@linux-foundation.org> AuthorDate: Wed Nov 14 17:00:41 2007 -0800
> Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
> CommitDate: Wed Nov 14 18:45:44 2007 -0800
> 
>     x86: disable preemption in delay_tsc()
>     
>     Marin Mitov points out that delay_tsc() can misbehave if it is
> preempted and rescheduled on a different CPU which has a skewed TSC.
> Fix it by disabling preemption.
>  

this worries me.. this appears to effectively disable preemption during
udelay() and mdelay() loops... which are very obvious latency inducers.

Now you can argue that if you're preemptible you should have used
msleep() and co, and I'll totally buy that. 


Maybe we should just check if we're still on the same cpu or something,
or have a cheap way to pin a process to a cpu.... but both are longer
term solutions.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
