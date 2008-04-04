Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbYDDEkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbYDDEkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 00:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYDDEkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 00:40:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159AbYDDEkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 00:40:04 -0400
Date: Thu, 3 Apr 2008 21:39:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Lubos Lunak <l.lunak@suse.cz>,
       Jan Kara <jack@suse.cz>, Petr Cvek <petr.cvek@tul.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>, Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc8-git2: Reported regressions from 2.6.24
Message-Id: <20080403213937.8344433e.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0804031649470.14670@woody.linux-foundation.org>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
	<alpine.LFD.1.00.0804031649470.14670@woody.linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008 16:59:02 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 4 Apr 2008, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10390
> > Subject		: Oops while reading /proc/ioports or /proc/iomem
> > Submitter	: Jan Kara <jack@suse.cz>
> > Date		: 2008-04-03 15:25 (1 days old)
> > References	: http://lkml.org/lkml/2008/4/3/149
> 
> This sounds very much like some module registered IO ports/memory and was 
> then unloaded without unregistering them.
> 
> It's a bit hard to guess which module it is, though. The oops says "[last 
> unloaded: parport]", so that's likely to be the area.
> 
> So I *suspect* this patch might be relevant. Bug apparently introduced in 
> f63fd7e299ee13da071ecfce2b90b58c5e1562b1 ("parport_pc: detection for 
> SuperIO IT87XX POST") by Petr Cvek.
> 
> Petr?
> 
> 		Linus
> 
> ---
>  drivers/parport/parport_pc.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
> index d76d37b..a858089 100644
> --- a/drivers/parport/parport_pc.c
> +++ b/drivers/parport/parport_pc.c
> @@ -1568,9 +1568,8 @@ static void __devinit detect_and_report_it87(void)
>  		outb(r | 8, 0x2F);
>  		outb(0x02, 0x2E);	/* Lock */
>  		outb(0x02, 0x2F);
> -
> -		release_region(0x2e, 1);
>  	}
> +	release_region(0x2e, 1);
>  }
>  #endif /* CONFIG_PARPORT_PC_SUPERIO */

Looks very correct to me.
