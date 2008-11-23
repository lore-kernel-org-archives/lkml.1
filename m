Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbYKWNvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbYKWNvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 08:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758059AbYKWNvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 08:51:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:17065 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034AbYKWNvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 08:51:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZEYHtHeEKIFT0U8Id8F23jlVu2poPd5cDFnY828zBNbFLShWTYYQbaq5ZCpAMnZlbd
         YSsXP3C+eQw5GkN5B6y0IedjdNnuQJywF0CQc3di+n1c+E+Ntb3sDjI/04Nlnj47nF61
         LFtC6FrqAjvSMWf+hk51gvhuiqddsB3tnjL7I=
Date: Sun, 23 Nov 2008 16:51:34 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: KPROBE_ENTRY should be paired wth KPROBE_END
Message-ID: <20081123135134.GH24818@localhost>
References: <20081120150412.GC13550@elte.hu> <20081120152601.GA3953@mailshack.com> <20081120153954.GA22511@elte.hu> <20081121154155.GA12999@mailshack.com> <20081121154318.GA13014@mailshack.com> <20081121154428.GB13014@mailshack.com> <20081121160629.GA24839@elte.hu> <20081123090828.GA31490@mailshack.com> <20081123091532.GA31515@mailshack.com> <20081123132752.GF1178@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123132752.GF1178@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, Nov 23, 2008 at 02:27:52PM +0100]
| 
| * Alexander van Heukelum <heukelum@mailshack.com> wrote:
| 
| > Impact: moves some code out of .kprobes.text
| > 
| > KPROBE_ENTRY switches code generation to .kprobes.text, and KPROBE_END
| > uses .popsection to get back to the previous section (.text, normally).
| > Also replace ENDPROC by END, for consistency.
| > 
| > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
| 
| applied to tip/x86/irq, thanks Alexander!
| 
| > One more small change for today. The xen-related functions 
| > xen_do_hypervisor_callback and xen_failsafe_callback are put
| > in the .kprobes.text even in the current kernel: ignore_sysret
| > is enclosed in KPROBE_ENTRY / ENDPROC, instead of KPROBE_ENTRY /
| > KPROBE_END, but I guess the situation is harmless.
| 
| yeah. It narrows no-kprobes protection for that code, but it should 
| indeed be fine (and that's the intention as well).
| 
| Note that this is a reoccuring bug type, and rather long-lived. Can 
| you think of any way to get automated nesting protection of both the 
| .cfi_startproc/endproc macros and kprobes start/end? A poor man's 
| solution would be to grep the number of start and end methods and 
| enforce that they are equal.
| 
| 	Ingo
| 

I think we could play with preprocessor and check if ENTRY/END matches.
Looking now.

		- Cyrill -
