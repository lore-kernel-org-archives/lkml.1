Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbYFRQjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbYFRQjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 12:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbYFRQjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 12:39:46 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:22503 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYFRQjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:39:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g77E4zN5XTRxi4wfiUjxbh1W6KRG1NozRGA661M4Csu63lwHhA6SJi0i56JDbD9tTl
         YYpxXJKnr3QM5L/fpeWIPVkkxz3Brw1ZEM8rEXkA+7XR3SRBRA1eMGFv4XZ0ux/SIXlD
         hE/XSyT+6R2+eRbM9xV52et9I/7aVsCnKC2jw=
Date: Wed, 18 Jun 2008 20:39:05 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: nmi_watchdog suspicious
Message-ID: <20080618163905.GB7117@cvg>
References: <20080610185759.GA7353@cvg> <Pine.LNX.4.55.0806160040270.11995@cliff.in.clinika.pl> <20080616170000.GC7273@cvg> <Pine.LNX.4.55.0806161819500.20218@cliff.in.clinika.pl> <20080617155120.GA9440@cvg> <Pine.LNX.4.55.0806181654450.4857@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0806181654450.4857@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Wed, Jun 18, 2008 at 05:06:29PM +0100]
| On Tue, 17 Jun 2008, Cyrill Gorcunov wrote:
| 
| > Thanks a lot Maciej for comments! I've marked them. I'm not sure but it seems
| > I wrote a bit unclear /my english bad indeed/ ;) I mean - this say 'slipping'
| > (ie useless code executions) _was_ before the patch applied. Now it doesn't
| > slip on this since we do mention explicitly in which case there should be
| > alert counters reset. Other then that - will try to handle your notes. Thanks!
| 
|  It will happen regardless if touch_nmi_watchdog() is called before the
| NMI watchdog has been set up in setup_nmi() or lapic_watchdog_init().  It
| may also happen during that window if an NMI is signalled without any NMI
| status bits set in the Port B register at 0x61 -- in theory that should
| not happen except for a broken configuration, but reality out there seems
| to be quite creative about breakage.
| 
|   Maciej
| 

Maciej, it seems we are talking about different code snippets ;)
I'm talking only about touch_nmi_watchdog(). By now (in -tip tree
we have)

void touch_nmi_watchdog(void)
{
	if (nmi_watchdog == NMI_LOCAL_APIC ||
		nmi_watchdog == NMI_IO_APIC) {
		unsigned cpu;
		...

so we check explicitly the values (so if touch_nmi_watchdog
was called when nmi_watchdog = 0 or -1U this code will not
be executed anyway). So I think I'm a bit lost, Maciej... I just
can't figure out what is wrong with this code, so please help
me ;). If you're talking about apic code in _general_ design
then...well, I think I need some time to _understand_ the code
say byte-by-byte first.

		- Cyrill -
