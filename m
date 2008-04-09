Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbYDIW1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbYDIW1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 18:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbYDIW1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 18:27:30 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57243 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbYDIW1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 18:27:30 -0400
Date: Wed, 9 Apr 2008 15:26:11 -0700
From: sukadev@us.ibm.com
To: Andrew Morton <akpm@osdl.org>
Cc: clg@fr.ibm.com, serue@us.ibm.com, "David C. Hansen" <haveblue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] clone64() and unshare64() system calls
Message-ID: <20080409222611.GA28087@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a resend of the patch set Cedric had sent earlier. I ported
the patch set to 2.6.25-rc8-mm1 and tested on x86 and x86_64.
---

We have run out of the 32 bits in clone_flags !

This patchset introduces 2 new system calls which support 64bit clone-flags.

     long sys_clone64(unsigned long flags_high, unsigned long flags_low,
		unsigned long newsp);

     long sys_unshare64(unsigned long flags_high, unsigned long flags_low);

The current version of clone64() does not support CLONE_PARENT_SETTID and 
CLONE_CHILD_CLEARTID because we would exceed the 6 registers limit of some 
arches. It's possible to get around this limitation but we might not
need it as we already have clone()

This is work in progress but already includes support for x86, x86_64, 
x86_64(32), ppc64, ppc64(32), s390x, s390x(31). 

ia64 already supports 64bits clone flags through the clone2() syscall.
should we harmonize the name to clone2 ?  
