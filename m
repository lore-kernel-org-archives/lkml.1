Return-Path: <linux-kernel-owner+w=401wt.eu-S1763293AbXGFPZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763293AbXGFPZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 11:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760269AbXGFPZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 11:25:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54769 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758960AbXGFPZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 11:25:01 -0400
Date: Fri, 6 Jul 2007 17:24:54 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] introduce panic_gently
In-Reply-To: <p73d4z520v6.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.58.0707061705260.2241@be1.lrz>
References: <Pine.LNX.4.58.0707060034330.18989@be1.lrz> <p73d4z520v6.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/jU7EMNrSQ7SiY6iAwjCxmEyx3HesTfKULkRN
 eUapKkK4/p3rkTTtZqNyiPBJoyFUcQrS2dpGTS57MCrjOl1+b4
 90b3qkig4hAH0R9Guucvg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007, Andi Kleen wrote:

> Bodo Eggert <7eggert@gmx.de> writes:
> 
> > If the boot process failes to find init or the root fs, the cause has 
> > usually scrolled off the screen, and because of the panic, it can't be 
> > reached anymore.
> > 
> > This patch introduces panic_gently, which will allow to use the scrollback 
> > buffer and to reboot, but it can't be called from unsafe context.
> 
> The implementation certainly has too much duplicated code. If anything
> it needs some common functions.

There are common parts, but they have subtile differences.
I'd rather make that function __init and not wory about that 200 bytes.


Maybe some parts can be skipped, too.

> The problem with keeping interrupts on is that the system might continue
> to route packets. This is sometimes quite unexpected for users.

> Arguably that's unlikely to be already enabled for missing root,
> but in theory initrd could have done it.

If initrd set up a router, it should should also do the mounts and call 
init, shouldn't it? In this case, the panic() won't ever happen.

(At least the kernel panic()s if I run rdinit=/bin/ash and exit that
 shell, therefore I can't depend on the kernel to execute init.)

> I think i would prefer if the normal panic() tried to detect the situations
> where this is 
> 
> It couldn't detect spinlocks, but interrupts off/interrupt context etc.

I asumed that to be the greater challenge, taking several months to get 
right instead of a few minutes. (I'm not sure I really got this right, but 
it happens to works for me.-)

-- 
Funny quotes:
36. You never really learn to swear until you learn to drive.
