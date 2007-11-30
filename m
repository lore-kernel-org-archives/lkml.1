Return-Path: <linux-kernel-owner+w=401wt.eu-S933424AbXK3GoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424AbXK3GoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 01:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756820AbXK3GoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 01:44:04 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51769 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754873AbXK3GoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 01:44:02 -0500
Message-Id: <20071130064305.459255715@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 Nov 2007 22:43:05 -0800
From: Christoph Lameter <clameter@sgi.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 0/3] Per cpu relocation to ZERO and x86_32 percpu ops on x86_64
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset allows the use of x86_32 percpu ops on x86_64 while maintaining
%gs pointing to the pda. It does that by moving the x86_64 pda into
the percpu area (thereby pointing %gs at the per cpu area) and then
relocating the x86_64 per cpu variables to start at 0.

Patch applies on top of the per cpu cleanup patches V2.
See http://marc.info/?l=linux-kernel&m=119628478316525&w=2

Ultimately I think we can make the per cpu accessors arch independent
(see the RFC at http://marc.info/?l=linux-kernel&m=119552126330405&w=2).
There is a performance benefit from using these in core code.

-- 
