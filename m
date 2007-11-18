Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbXKRRk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbXKRRk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 12:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbXKRRkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 12:40:20 -0500
Received: from fencepost.gnu.org ([140.186.70.10]:42671 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbXKRRkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 12:40:18 -0500
Subject: Need help with register_page_fault_notifier() replacement in 2.6.24
From: Pavel Roskin <proski@gnu.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 18 Nov 2007 12:40:16 -0500
Message-Id: <1195407616.26789.15.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I'm trying to update a special tracing version of madwifi (driver for
Atheros wireless cards) for Linux 2.6.24.  This version was created to
help reverse engineering the non-free part of the driver (also known as
HAL, hardware abstraction layer).

The problem is that functions register_page_fault_notifier() and
unregister_page_fault_notifier() are gone in the current kernel git
repository.

They are needed to intercept access to the card by causing page fault
and intercepting it.

Those functions were removed on i386 platform because kprobes now
registers the flat handler directly.  The log says that other callers
are supposed to use kprobes now.

But what would be the right way to do it?  I can intercept
do_page_fault() with kprobes, but that looks unsafe, since
do_page_fault() is used by kprobes internally.

Or maybe I should install a fault handler with register_kprobe()?  The
problem is, it is only called for faults in kp->pre_handler and
kp->post_handler and for single-stepping.  I don't want to single-step
anything, and moving all driver functionality in kp->pre_handler would
be strange.

Perhaps I'm missing something obvious.  Any help will be appreciated.

-- 
Regards,
Pavel Roskin

