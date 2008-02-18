Return-Path: <linux-kernel-owner+w=401wt.eu-S1761797AbYBRNNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761797AbYBRNNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761577AbYBRNMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:12:52 -0500
Received: from www.tglx.de ([62.245.132.106]:41963 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760873AbYBRNMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:12:51 -0500
Date: Mon, 18 Feb 2008 14:12:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Quel Qun <kelk1@comcast.net>
cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, marcel@holtmann.org
Subject: Re: Kernel oops with bluetooth usb dongle
In-Reply-To: <021820080001.29293.47B8CAD10009FD170000726D2207000953CE05040A05@comcast.net>
Message-ID: <alpine.LFD.1.00.0802181245370.7583@apollo.tec.linutronix.de>
References: <021820080001.29293.47B8CAD10009FD170000726D2207000953CE05040A05@comcast.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008, Quel Qun wrote:

Added bluetooth wizards to CC

> > Can you please enable CONFIG_SLUB_DEBUG=y and CONFIG_SLUB_DEBUG_ON=y
> > and give it another try?
> > 
> > If we can not catch it that way, I'll whip up a patch which points us
> > to the code which added the offending timer.
> > 
> Hi,
> 
> Note: I switched to 2.6.25-rc2. The only new thing I see is this message:
> 
> hci_cmd_task: hci0 command tx timeout
> 
> This comes from net/bluetooth/hci_core.c, line 1547
> 
> There is indeed a timeout message in the log (at the end of this
> email). I tried to boot with slub_debug but did not get anything
> more. slabinfo -v does not report anything either.
>
> Crash log:
> 
> hci_cmd_task: hci0 command tx timeout
> BUG: unable to handle kernel paging request at 6b6b6b6b

We got some more info ---------------------------^^^^^^^^
#define POISON_FREE      0x6b    /* for use-after-free poisoning */

So the timer is in an allocated data structure, which is
freed without having removed the timer first.

> Sorry for the meager yield.

Hey, we know already more :)

Marcel, any idea on this one ?

Thanks,
	tglx
