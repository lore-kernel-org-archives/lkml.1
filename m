Return-Path: <linux-kernel-owner+w=401wt.eu-S1161428AbXBZXwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161428AbXBZXwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 18:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161421AbXBZXwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 18:52:38 -0500
Received: from gundega.hpl.hp.com ([192.6.19.190]:64923 "EHLO
	gundega.hpl.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161428AbXBZXwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 18:52:37 -0500
Date: Mon, 26 Feb 2007 15:51:54 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: linux-kernel@vger.kernel.org
Cc: linux-ia64@vger.kernel.org, Stephane Eranian <eranian@hpl.hp.com>,
       ak@suse.de, akpm@linux-foundation.org, tony.luck@intel.com
Subject: debug registers and fork
Message-ID: <20070226235154.GB19630@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have come across an issue with a monitoring using the
hardware debug registers on ia64/i386/x86-64.

It seems that the way debug registers are inherited across fork
differs between ia-64 and i386/x86-64. On ia-64, the debug registers
are NEVER inherited in the child. The copy_thread() routine clears
the necessary thread flags to avoid reloading the debug registers in
the child.

Now, on x86-64, it appears that the TIF_DEBUG flag is inherited via
setup_thread_stack(). By virtue of dup_task_struct() the debug registers
get copied into the child task on fork. So the child has active breakpoints,
unless I am mistaken somewhere.

Given the way the ptrace() interface works, I would tend to
think that the ia-64 way is the correct one. Any comment?

Furthermore, on i386/x86-64, when switching out from a task with TIF_DEBUG
enabled to another which does not, it seems we do not clear the debug
registers (at least dr7) so they become inactive.

-- 
-Stephane
