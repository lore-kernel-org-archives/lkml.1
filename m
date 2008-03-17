Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbYCQRw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbYCQRw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 13:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbYCQRwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 13:52:20 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:34099 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbYCQRwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 13:52:19 -0400
Date: Mon, 17 Mar 2008 20:57:12 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Bsd_acct: using task_struct->tgid is not right in pid-namespaces
Message-ID: <20080317175712.GB115@tv-sign.ru>
References: <47DE4D43.2040404@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DE4D43.2040404@openvz.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17, Pavel Emelyanov wrote:
>
> In case we're accounting from a sub-namespace,

Offtopic. Bsd-accounting is system wide. I can't understand what should
we do if multiple namespaces do acct_on().

> the tgids
> reported will not refer to the right namespace.

I think the patch is correct, but let's suppose that a sub-namespace does
accounting, and the task from the parent namespace exits. With this patch
we report ac.ac_pid == 0, which is a bit strange. But the question is,
should we see the tasks from the parent namespace at all?

Perhaps, the task shouldn't account itself if it doesn't "belong" to
acct_globals.ns ? In that case we don't need other changes to figure
out ac.ac_pid/ac_ppid.

Better yet, perhaps acct_on() should be forbidden for non-root ns?

(but the patch itself is correct afaics)

Oleg.

