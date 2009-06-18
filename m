Return-Path: <linux-kernel-owner+w=401wt.eu-S1752283AbZFRIVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbZFRIVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 04:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbZFRIUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 04:20:49 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:45341 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbZFRIUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 04:20:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19001.63708.989256.78908@cargo.ozlabs.ibm.com>
Date: Thu, 18 Jun 2009 18:20:44 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Accessing user memory from NMI
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What was the conclusion you guys came to about doing a user stack
backtrace in an NMI handler?  Are you going to access user memory
directly or are you going to use the __fast_get_user_pages approach?

Ben H and I were talking today about what we'd need in order to be
able to read user memory in a PMU interrupt handler.  It looks like we
could read user memory directly with a bit of care, on 64-bit at
least.  Because of the MMU hash table that would almost always work
provided the page has already been touched (which stack pages would
have been), but there is a small chance that the access might fail
even if the address has a valid PTE.  At that point we could fall back
to the __fast_get_user_pages method, but I'm not sure it's worth it.

Paul.
