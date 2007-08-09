Return-Path: <linux-kernel-owner+w=401wt.eu-S966085AbXHIPHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966085AbXHIPHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765067AbXHIPHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:07:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:40819 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760191AbXHIPHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:07:20 -0400
To: Phil Moors <pmoors@speakeasy.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: EDAC k8 MC1: unknown syndrome
References: <20070809141333.GA10188@speakeasy.net>
From: Andi Kleen <andi@firstfloor.org>
Date: 09 Aug 2007 18:01:38 +0200
In-Reply-To: <20070809141333.GA10188@speakeasy.net>
Message-ID: <p73d4xwg0il.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phil Moors <pmoors@speakeasy.net> writes:
> 
> But is the error really reporting a DIMM problem or a race condition in
> the kernel code handling ECC?

First if you don't use a mainline kernel you should at least mention
it in the report.

It could well be a race -- the k8 DAC code is always racing against
the builtin machine check handler which reads the same registers.
That is why it was never accepted for mainline and shouldn't be used.

However these races should normally only cause lost events, not
bogus data, so it's probably something the CPU really reported
and EDAC doesn't understand.

The builtin machine check code will report all the same information
through mcelog (on x86-64) or syslog (on i386)

-Andi
