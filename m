Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbXJARgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbXJARgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 13:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXJARgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 13:36:06 -0400
Received: from mail.suse.de ([195.135.220.2]:44840 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbXJARgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 13:36:05 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "David Bahi" <dbahi@novell.com>
Subject: Re: nmi_watchdog fix for x86_64 to be more like i386
Date: Mon, 1 Oct 2007 19:36:01 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       tglx@linutronix.de, "Gregory Haskins" <GHaskins@novell.com>
References: <46FA4A800200006C000192FE@sinclair.provo.novell.com>
In-Reply-To: <46FA4A800200006C000192FE@sinclair.provo.novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710011936.01528.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 September 2007 20:03:12 David Bahi wrote:
> Thanks to tglx and ghaskins for all the help in tracking down a very
> early nmi_watchdog crash on certain x86_64 machines.

The patch is totally bogus. irq 0 doesn't say anything about whether
the current CPU still works or not. You always need some local
interrupt. This basically disables the NMI watchdog for the non boot CPUs.

It's even wrong on i386 -- i wonder how that broken patch
made it in there. I'll remove it there.

-Andi
