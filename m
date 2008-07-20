Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbYGTIsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbYGTIsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 04:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbYGTIsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 04:48:08 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:36001 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbYGTIsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 04:48:06 -0400
Date: Sun, 20 Jul 2008 12:51:39 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: kill mm->core_done
Message-ID: <20080720085139.GB143@tv-sign.ru>
References: <20080715140715.GA25824@tv-sign.ru> <20080720032001.E707315421D@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080720032001.E707315421D@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19, Roland McGrath wrote:
>
> It is indeed ugly.  I think the place to start is with moving all the
> coredump code out of exit_mm() into a new subfunction that is just passed
> the mm pointer, and doing the same with coredump_finish() as you've done,
> but leaving the completion logic inside those functions the same.

The next patch does this.

This patch goes first because it kills the last field in mm_struct which
is needed for the coredump code, so new new function (exit_coredump) doesn't
need the mm pointer at all.

Oleg.

