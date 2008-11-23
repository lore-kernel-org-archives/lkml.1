Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbYKWL0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbYKWL0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 06:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbYKWL02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 06:26:28 -0500
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:12601 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbYKWL02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 06:26:28 -0500
Date: Sun, 23 Nov 2008 12:23:54 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Beulich <jbeulich@novell.com>, Glauber Costa <gcosta@redhat.com>,
       Matt Mackall <mpm@selenic.com>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] x86: include ENTRY/END in entry handlers in entry_64.S
Message-ID: <20081123112354.GA31667@mailshack.com>
References: <20081120134011.GA3627@mailshack.com> <20081120150412.GC13550@elte.hu> <20081120152601.GA3953@mailshack.com> <20081120153954.GA22511@elte.hu> <20081121154155.GA12999@mailshack.com> <20081121154318.GA13014@mailshack.com> <20081121154428.GB13014@mailshack.com> <20081121160629.GA24839@elte.hu> <20081123090828.GA31490@mailshack.com> <20081123092136.GC24818@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123092136.GC24818@localhost>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Sun, 23 Nov 2008 12:25:55 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.35; VDF: 7.1.0.122; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 12:21:36PM +0300, Cyrill Gorcunov wrote:
> [Alexander van Heukelum - Sun, Nov 23, 2008 at 10:08:28AM +0100]
> | Impact: cleanup of entry_64.S
> | 
> | Except for the order and the place of the functions, this
> | patch should not change the generated code.
> | 
> | Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> | 
> | ---
> |  arch/x86/kernel/entry_64.S |  259 +++++++++++++++++++-------------------------
> |  1 files changed, 109 insertions(+), 150 deletions(-)
> |
> 
> Hi Alexander,
> 
> great! One moment is not obvious for me -- why we
> stopped to align interrupt section to 32 bytes?
> Did I miss anyhing?

I put a ".p2align 5" in earlier in the series which caused the
apicinterrupts to be 32-byte aligned. But it is a hack, really,
relying on the generated code per stub to be between 17 and 32
bytes, on the default alignment to be 16 bytes and all stubs
to be in the .text section.

I'm in favour of aligning all of the interrupt/exception stubs
to 32 bytes, but it should be implemented the right way ;),
which means that we need KPROBE_ENTRY_P5ALIGNED and so on :-/.

Greetings,
        Alexander
 
> 		- Cyrill -
