Return-Path: <linux-kernel-owner+w=401wt.eu-S1750940AbXBLAES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750940AbXBLAES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 19:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbXBLAES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 19:04:18 -0500
Received: from mail.screens.ru ([213.234.233.54]:36943 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbXBLAER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 19:04:17 -0500
Date: Mon, 12 Feb 2007 03:04:10 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] make queue_delayed_work() friendly to flush_fork()
Message-ID: <20070212000410.GA91@tv-sign.ru>
References: <20070210215040.GA2213@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070210215040.GA2213@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11, Oleg Nesterov wrote:
> 
> This makes impossible to use flush_fork(delayed_work->work) in addition
> to cancel_delayed_work/cancel_rearming_delayed_work, not good.

It turns out this patch is in fact bug-fix.

I didn't notice that we already have flush_fork(delayed_work) calls!

This means that
	workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
	and this patch

should go just after
	implement-flush_work.patch

Sorry for inconvenience, please apply.

Oleg.

