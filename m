Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbXEUIbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbXEUIbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759377AbXEUIa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:30:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:12955 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbXEUIa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:30:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=rmzVTUm7hvk67jerLS3TPQvqkM2rlD/79JlQ7Kqyp3+wD2Skd1W4o5vvgDyPsHALo7tpvrfr6g4U0RglCuQcC+GLQ0npEYMggYNQ8uxU7ct+rYhWj1Fu6Y9KBPcdYwgOi5JROGRB3x6U7IgqGKnNAppgOn7BE0KRK+r5RCvUcPQ=
Message-ID: <465158BD.4030609@gmail.com>
Date: Mon, 21 May 2007 10:30:53 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Dan Kruchinin <dubalom@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [RFC] linux-2.6.22-rc2. SLUB report[kzalloc(0)]
References: <1179713102.4969.14.camel@midgard>
In-Reply-To: <1179713102.4969.14.camel@midgard>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Kruchinin napsal(a):
> Hi.
> 
> There is a BUG message from SLUB during boot process:
> --
> May 21 05:39:10 midgard kernel: [   31.177484] BUG: at
> include/linux/slub_def.h:77 kmalloc_index()
> May 21 05:39:10 midgard kernel: [   31.178355]  [<c01062ca>]
> show_trace_log_lvl+0x1a/0x30
> May 21 05:39:10 midgard kernel: [   31.179263]  [<c0106e72>] show_trace
> +0x12/0x20
> May 21 05:39:10 midgard kernel: [   31.180177]  [<c0106ee6>] dump_stack
> +0x16/0x20
> May 21 05:39:10 midgard kernel: [   31.181094]  [<c018440d>] get_slab
> +0x1cd/0x260
> May 21 05:39:10 midgard kernel: [   31.182024]  [<c0185809>]
> __kmalloc_track_caller+0x19/0xa0
> May 21 05:39:10 midgard kernel: [   31.183019]  [<c0170059>] __kzalloc
> +0x19/0x50
> May 21 05:39:10 midgard kernel: [   31.184012]  [<df05586e>]
> usb_get_configuration+0x9de/0x11c0 [usbcore]
> May 21 05:39:10 midgard kernel: [   31.185115]  [<df04cd07>]
> usb_new_device+0x17/0x190 [usbcore]
> May 21 05:39:10 midgard kernel: [   31.186181]  [<df04e68a>] hub_thread
> +0x79a/0xfd0 [usbcore]
> May 21 05:39:10 midgard kernel: [   31.187185]  [<c013b8e2>] kthread
> +0x42/0x70
> May 21 05:39:10 midgard kernel: [   31.188190]  [<c0105ea7>]
> kernel_thread_helper+0x7/0x10
> --
> 
> kzalloc(0, GFP_KERNEL) occurs in drivers/usb/core/config.c in 
> usb_get_configuration function. I already wrote about this slub bug
> report and offered a
> patch(http://www.uwsg.iu.edu/hypermail/linux/kernel/0705.1/0154.html). I
> don't know, may be it is not major thing, if it is, just ignore it. I
> just think, that 
> --
> 	length = ncfg * sizeof(struct usb_host_config);
> 	dev->config = kzalloc(length, GFP_KERNEL);
> --
> isn't clear, because ncfg - in my case - is 0 and I suppose, that size
> of the leastest slab cache can become(in future) smaller than
> sizeof(struct usb_host_config).

There is yet another patch for this:
http://lkml.org/lkml/2007/5/19/171
sitting here:
http://kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-03-usb/usb-don-t-try-to-kzalloc-0-bytes.patch

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
