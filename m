Return-Path: <linux-kernel-owner+w=401wt.eu-S1761969AbYA2EZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761969AbYA2EZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 23:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbYA2EZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 23:25:21 -0500
Received: from ns1.suse.de ([195.135.220.2]:39952 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772AbYA2EZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 23:25:19 -0500
From: Andi Kleen <ak@suse.de>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: down_killable implementations for every architecture
Date: Tue, 29 Jan 2008 05:23:52 +0100
User-Agent: KMail/1.9.1
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080128231918.GB31101@parisc-linux.org>
In-Reply-To: <20080128231918.GB31101@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801290523.52993.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008 00:19, Matthew Wilcox wrote:
> As part of the TASK_KILLABLE changes, we're going to need
> down_killable().  Unfortunately, semaphores are implemented for every
> architecture, which we should probably fix at some point.

It would be best to just change it now before doing further changes. Right now
we have the bizarre situation that semaphores are more optimized
with fast path inline assembly code than the far more critical spinlocks.
But that clearly doesn't make much sense. So the best approach would
be likely to just pick some generic C implementation from some architecture
and use it everywhere.

-Andi
