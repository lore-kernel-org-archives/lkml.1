Return-Path: <linux-kernel-owner+w=401wt.eu-S934341AbYETWBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934341AbYETWBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763752AbYETWAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:00:53 -0400
Received: from mx1.suse.de ([195.135.220.2]:43666 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759703AbYETWAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:00:52 -0400
From: Andreas Schwab <schwab@suse.de>
To: Trent Piepho <tpiepho@freescale.com>
Cc: linuxppc-dev@ozlabs.org, Scott Wood <scottwood@freescale.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
References: <1211316025-29069-1-git-send-email-tpiepho@freescale.com>
X-Yow: I want a WESSON OIL lease!!
Date: Wed, 21 May 2008 00:00:51 +0200
In-Reply-To: <1211316025-29069-1-git-send-email-tpiepho@freescale.com> (Trent
	Piepho's message of "Tue, 20 May 2008 13:40:25 -0700")
Message-ID: <jeiqx83ab0.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trent Piepho <tpiepho@freescale.com> writes:

> For the LE versions, eventually they boil down to an asm that will look
> something like this:
> asm("sync; stwbrx %1,0,%2" : "=m" (*addr) : "r" (val), "r" (addr));
>
> While not perfect, this appears to be the best one can do.  The issue is
> that the "stwbrx" instruction only comes in an indexed, or 'x', version, in
> which the address is represented by the sum of two registers (the "0,%2").
> Unfortunately, gcc doesn't have a constraint for an indexed memory
> reference.

There is the "Z" constraint, which matches either an indirect or an
indexed memory address.  That should fit here.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
