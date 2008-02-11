Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbYBKJ7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbYBKJ7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYBKJ6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:58:55 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:33969 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYBKJ6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:58:54 -0500
Message-Id: <20080211095806.585883882@fr.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 11 Feb 2008 10:58:06 +0100
From: clg@fr.ibm.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xemul@openvz.org, serue@us.ibm.com
Subject: [patch 0/3] clone64() and unshare64() syscalls
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yet another try to extend the clone flags and probably not the last !

This patchset adds 2 new syscalls :

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


Please see the changelog below.

C.

