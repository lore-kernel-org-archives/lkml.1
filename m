Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbYEWNVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbYEWNVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756968AbYEWNUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:20:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37267 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511AbYEWNUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:20:44 -0400
Date: Fri, 23 May 2008 14:20:34 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [RFC] Circular include dependencies
Message-ID: <20080523132034.GB15384@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Having discovered some circular include dependencies in the ARM header
files which were causing build issues, I created a script to walk ARM
includes and report any similar issues found - which includes traversing
any referenced linux/ includes.

It identified the following two in include/linux/:

  linux/mmzone.h <- linux/memory_hotplug.h <- linux/mmzone.h
  linux/mmzone.h <- linux/topology.h <- linux/mmzone.h

Checking them by hand reveals that these are real.  Whether they're
capable of causing a problem or not, I'm not going to comment on.
However, they're not a good idea and someone should probably look at
resolving the loops.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
