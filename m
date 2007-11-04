Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbXKDXGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbXKDXGA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 18:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbXKDXFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 18:05:53 -0500
Received: from mail.suse.de ([195.135.220.2]:58716 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbXKDXFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 18:05:52 -0500
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
       tglx@linutronix.de
Subject: Re: [PATCH] fix i486 boot failure due to stale %ds
From: Andi Kleen <andi@firstfloor.org>
References: <200711042158.lA4Lwv9S014628@harpo.it.uu.se>
Date: Mon, 05 Nov 2007 00:05:48 +0100
In-Reply-To: <200711042158.lA4Lwv9S014628@harpo.it.uu.se> (Mikael Pettersson's message of "Sun\, 4 Nov 2007 22\:58\:57 +0100 \(MET\)")
Message-ID: <p733avl392r.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson <mikpe@it.uu.se> writes:

> Maybe not. I had a look in Intel's SDM Vol3, and the
> section "switching to protected mode" specifies that
> a move to %cr0 that sets PE should immediately be
> followed by a far jmp or call. They write that "random
> failures can occur if other instructions exist between
> [the move to %cr0] and [the far jmp/call]". The current
> version of pmjump.S does exactly that: it executes
> a bunch of moves to segment registers in that window.

iirc various Intel VT hypervisor implementations also have trouble
with not following this restriction. At least in the early Xen
days it was a frequent reason for boot failure.

-Andi
