Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbXJ0TFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbXJ0TFR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 15:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbXJ0TFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 15:05:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:33135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbXJ0TFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 15:05:01 -0400
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix x86_64 TIF_SYSCALL_TRACE race in entry.S
From: Andi Kleen <andi@firstfloor.org>
References: <20071026193738.GA1591@Krystal> <20071027180837.GA18134@Krystal>
Date: Sat, 27 Oct 2007 21:04:57 +0200
In-Reply-To: <20071027180837.GA18134@Krystal> (Mathieu Desnoyers's message of "Sat\, 27 Oct 2007 14\:08\:37 -0400")
Message-ID: <p73sl3wnzty.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <compudj@krystal.dyndns.org> writes:

> We make sure that the thread flag read is coherent between our new test and the ALLWORK_MASK test by first saving it in a register used for both comparisons.
>

That doesn't make sense. If someone is setting those asynchronously you 
can always race.

You should really just stop the process like ptrace does before changing
such things.

-Andi

