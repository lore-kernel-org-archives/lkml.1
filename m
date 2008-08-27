Return-Path: <linux-kernel-owner+w=401wt.eu-S1756468AbYH0N1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468AbYH0N1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbYH0N1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:27:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:39702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967AbYH0N1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:27:13 -0400
From: Thomas Renninger <trenn@suse.de>
To: ak@linux.intel.com
Cc: bjorn.helgaas@hp.com, linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       linux-acpi@vger.kernel.org, ckornacker@suse.de
Subject: Introduce interface to report BIOS bugs (reworked, FW_BUG simple solution)
Date: Wed, 27 Aug 2008 15:27:08 +0200
Message-Id: <1219843631-26015-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <200808210919.07642.bjorn.helgaas@hp.com>
References: <200808210919.07642.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even simplier, using FW_BUG define. I agree that the first implementation
was over-designed, I somehow liked the printk_fw_err() and printk_fw_info()
more, looked somehow more consistent with:

#define pr_info(fmt, arg...) \
        printk(KERN_INFO fmt, ##arg)
(and others).

Hmm, it shouldn't really matter.
I wonder whether it works out that messages are hidden to the ordinary
user with printk(KERN_INFO FW_BUG...).
Something that vendors get an idea that they should not do this, but
hiding it on a normally booted system is needed (but e.g. show it on a
linuxfirmwarekit booted kernel).

printk(KERN_DEBUG FW_BUG...)
Won't work because there you get too much output?
Are these patches sufficient to achieve above?

      Thomas

PS: Forgot to add Pavel to CC who also commented on previous patches,
it's work to do it right now, I expect you read this anyway.



