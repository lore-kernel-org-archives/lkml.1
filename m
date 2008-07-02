Return-Path: <linux-kernel-owner+w=401wt.eu-S1762504AbYGBG2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762504AbYGBG2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 02:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbYGBG16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 02:27:58 -0400
Received: from ozlabs.org ([203.10.76.45]:51288 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653AbYGBG15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 02:27:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18539.8141.683072.967851@cargo.ozlabs.ibm.com>
Date: Wed, 2 Jul 2008 16:27:25 +1000
From: Paul Mackerras <paulus@samba.org>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Is sysfs the right place to get cache and CPU topology info?
X-Mailer: VM 8.0.9 under Emacs 22.1.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm being asked by library developers about what is the best way for
them to get information about the CPU cache structure and the CPU
topology from the kernel.  When I said "x86 puts it in sysfs and we'll
do the same on powerpc" I got a response pointing me at this statement
in Documentation/sysfs-rules.txt (the first paragraph):

"The kernel-exported sysfs exports internal kernel implementation details
 and depends on internal kernel structures and layout. It is agreed upon
 by the kernel developers that the Linux kernel does not provide a stable
 internal API. As sysfs is a direct export of kernel internal
 structures, the sysfs interface cannot provide a stable interface either;
 it may always change along with internal kernel changes."

They read that to mean that sysfs is not a suitable interface for them
to use to get information about the system.  In particular they read
that to mean that if they do code their library to read sysfs, it will
change in the future in such a way as to break their code.

In other words, they see sysfs as being completely useless for them
because they can't depend on it as a stable interface.  Which is
reasonable given the quoted paragraph, but on the other hand, I don't
believe we break userspace interfaces as blithely as that paragraph
suggests.

So which is it?  Can they rely on the CPU cache and topology
information under /sys/devices/system/cpu/cpu*, and rely on having
that information there essentially forever?  Or are they correct in
saying sysfs is useless and we need to find some other way to expose
the cache and topology information?

Thanks,
Paul.
