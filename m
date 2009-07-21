Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbZGUP4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbZGUP4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbZGUP4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:56:24 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:44335 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbZGUP4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:56:23 -0400
Date: Tue, 21 Jul 2009 17:56:20 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
Message-ID: <20090721155620.GB13236@buzzloop.caiaq.de>
References: <20090721004531.1036d9af@lxorguk.ukuu.org.uk> <Pine.LNX.4.44L0.0907211141180.2652-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0907211141180.2652-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 11:53:35AM -0400, Alan Stern wrote:
> [  961.903814]  [<c1021755>] warn_slowpath_null+0xd/0x10
> [  961.903907]  [<c103ed98>] __lock_acquire+0x395/0xaf5
> [  961.903999]  [<c103ddb9>] ? mark_lock+0x1e/0x1e4
> [  961.904020]  [<c103f540>] lock_acquire+0x48/0x64
> [  961.904020]  [<c1126810>] ? tty_port_close_start+0x1a/0x118
> [  961.904020]  [<c11c21ef>] _spin_lock_irqsave+0x2e/0x3e
> [  961.904020]  [<c1126810>] ? tty_port_close_start+0x1a/0x118
> [  961.904020]  [<c1126810>] tty_port_close_start+0x1a/0x118
> [  961.904020]  [<f09649b5>] serial_close+0x4f/0x7b [usbserial]
> [  961.904020]  [<c11215e3>] tty_release_dev+0x17c/0x400
> [  961.904020]  [<c103d28e>] ? register_lock_class+0x17/0x272
> [  961.904020]  [<c1121879>] tty_release+0x12/0x1c
> [  961.904020]  [<c107201f>] __fput+0xe9/0x172
> [  961.904020]  [<c10720c1>] fput+0x19/0x1c
> [  961.904020]  [<c106f93c>] filp_close+0x51/0x5b
> [  961.904020]  [<c106f9b0>] sys_close+0x6a/0xa4
> [  961.904020]  [<c1002a08>] sysenter_do_call+0x12/0x36
> [  961.904020] ---[ end trace ed6ce19124f40616 ]---
> 
> This is only a lockdep warning, and I don't understand its
> significance.  Even worse, when I plugged in a USB flash drive
> afterward this appeared:

The problem is that freed resources are accessed, and that can lead to
any kind of strange kernel faults from crashing to other subsequent
errors.

Did you try my patch?

