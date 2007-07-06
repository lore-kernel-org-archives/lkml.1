Return-Path: <linux-kernel-owner+w=401wt.eu-S1762925AbXGFLKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762925AbXGFLKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 07:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759656AbXGFLKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 07:10:23 -0400
Received: from mx1.suse.de ([195.135.220.2]:45148 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758384AbXGFLKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 07:10:22 -0400
To: Bodo Eggert <7eggert@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] introduce panic_gently
References: <Pine.LNX.4.58.0707060034330.18989@be1.lrz>
From: Andi Kleen <andi@firstfloor.org>
Date: 06 Jul 2007 14:05:49 +0200
In-Reply-To: <Pine.LNX.4.58.0707060034330.18989@be1.lrz>
Message-ID: <p73d4z520v6.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert <7eggert@gmx.de> writes:

> If the boot process failes to find init or the root fs, the cause has 
> usually scrolled off the screen, and because of the panic, it can't be 
> reached anymore.
> 
> This patch introduces panic_gently, which will allow to use the scrollback 
> buffer and to reboot, but it can't be called from unsafe context.

The implementation certainly has too much duplicated code. If anything
it needs some common functions.

The problem with keeping interrupts on is that the system might continue
to route packets. This is sometimes quite unexpected for users.

Arguably that's unlikely to be already enabled for missing root,
but in theory initrd could have done it.

I think i would prefer if the normal panic() tried to detect the situations
where this is 

It couldn't detect spinlocks, but interrupts off/interrupt context etc.

-Andi
