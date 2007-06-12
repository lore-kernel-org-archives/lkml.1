Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbXFLIiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbXFLIiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 04:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbXFLIiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 04:38:01 -0400
Received: from science.horizon.com ([192.35.100.1]:11262 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751287AbXFLIiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 04:38:00 -0400
Date: 12 Jun 2007 04:37:58 -0400
Message-ID: <20070612083758.23401.qmail@science.horizon.com>
From: linux@horizon.com
To: linux-kernel@vger.kernel.org, wli@holomorphy.com
Subject: Re: divorce CONFIG_X86_PAE from CONFIG_HIGHMEM64G
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Given that incomprehensible help texts are a bit of a pet peeve of mine
(I just last weekend figured out that you don't need to select an I2C
algorithm driver to have working I2c - I had thought it was a "one from
column A, one from column B" thing), let me take a crack...

	PAE doubles the size of each page table entry, increasing
	kernel memory consumption and slowing page table access.
	However, it enables:
	- Addressing more than 4G of physical RAM (CONFIG_HIGHMEM is
	  also required)
	- Marking pages as readable but not executable using the NX
	  (no-execute) bit, which protects applications from stack
	  overflow attacks.
	- Swap files or partitions larger than 64G each.
	  (Only needed with >4G RAM or very heavy tmpfs use.)

	A kernel compiled with this option cannot boot on a processor
	without PAE support.  Enabling this also disables the
	(expert use only) CONFIG_VMSPLIT_[23]G_OPT options.

Does that seem reasonably user-oriented?
