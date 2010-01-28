Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331Ab0A1LN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab0A1LN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 06:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829Ab0A1LNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 06:13:55 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:50360 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab0A1LNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 06:13:54 -0500
Date: Thu, 28 Jan 2010 16:43:47 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jan Kiszka <jan.kiszka@siemens.com>
Subject: [Patch 0/2 v2] Improvements for hw_breakpoint_handler()
Message-ID: <20100128111347.GA13935@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,
        Can you please pull the second version of the patch which perform
the  following.

Patch 1/2: Clears the arch-reserved bits from debug status register. This
helps easy bitwise operations - such as the check for non-trap bits in
hw_breakpoint_handler. A check for the same using
"if (dr6 & (~DR_TRAP_BITS))" throws incorrect results due to the
presence of preset reserved bits.

Patch 2/2: Return NOTIFY_DONE from hw_breakpoint_handler() for interested
user-space breakpoints (and not unconditionally) since this could lead to
further processing in do_debug() with undesirable consequences.

Changelog ver II
----------------
Version I: LKML ref: 20091226182519.GA9494@in.ibm.com

- Return NOTIFY_DONE for further processing (i.e. signal delivery) only for
  interested user-space breakpoints i.e. with current->thread.debugreg6 bits
  set.

Thanks,
K.Prasad

