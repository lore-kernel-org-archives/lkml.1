Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbYDATsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbYDATsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 15:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756897AbYDATsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 15:48:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676AbYDATsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 15:48:37 -0400
Date: Tue, 1 Apr 2008 15:48:36 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [patch 0/3] dynamic printk
Message-ID: <20080401194836.GB12029@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

Add the ability to dynamically enable/disable pr_debug()/dev_dbg() in the
kernel. Yes, these calls could be converted to printk(KERN_DEBUG), but there
are enough to cause overhead. Additionally, the logs become difficult to read.
Here, one can turn on and off these messages per .c source file via:

echo "add file.c" > /sys/kernel/debug/dynamic_printk/files
echo "remove file.c" > /sys/kernel/debug/dynamic_printk/files

There is also a special 'all' value that turns on all the debugging messages.

I hope that these patches are useful for people writing new kernel code, for
system debugging and testing. In enabling the 'all' feature on the kernel I was
running i got a bunch of messages... (i'm not sure what they mean, but they
could point out an error or a kernel optimization that could be made, which I 
didn't necessarily know about otherwise).

thanks,

-Jason

Apr  1 10:33:38 dhcp83-106 kernel: Already setup manip DST for ct ffff81007d800140
Apr  1 10:33:38 dhcp83-106 kernel: Already setup manip SRC for ct ffff81007d800140
Apr  1 10:33:38 dhcp83-106 kernel: Already setup manip DST for ct ffff81007d800a00
Apr  1 10:33:38 dhcp83-106 kernel: Already setup manip SRC for ct ffff81007d800a00
Apr  1 10:33:39 dhcp83-106 kernel: Already setup manip DST for ct ffff81007d800a00
Apr  1 10:33:39 dhcp83-106 kernel: Already setup manip SRC for ct ffff81007d800a00
Apr  1 10:33:39 dhcp83-106 kernel: Already setup manip DST for ct ffff81007d800a00
Apr  1 10:33:39 dhcp83-106 kernel: Already setup manip SRC for ct ffff81007d800a00
Apr  1 10:33:40 dhcp83-106 kernel: Already setup manip DST for ct ffff810071851dc0
Apr  1 10:33:40 dhcp83-106 kernel: Already setup manip SRC for ct ffff810071851dc0
Apr  1 10:33:40 dhcp83-106 kernel: Already setup manip DST for ct ffff81007d800a00
Apr  1 10:33:40 dhcp83-106 kernel: Already setup manip SRC for ct ffff81007d800a00


