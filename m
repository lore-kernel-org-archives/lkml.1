Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab0BAVwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 16:52:04 -0500
Received: from www.steve.org.uk ([80.68.85.46]:54729 "EHLO skx.xen-hosting.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751381Ab0BAVwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 16:52:01 -0500
X-Greylist: delayed 919 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Feb 2010 16:52:00 EST
Date: Mon, 1 Feb 2010 21:36:35 +0000
From: Steve Kemp <kernel@steve.org.uk>
To: linux-kernel@vger.kernel.org
Subject: Possible NULL pointer dereference in m32r
Message-ID: <20100201213635.GA24391@steve.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-added-header: www.steve.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   arch/m32r/kernel/smp.c contains the following code:

--
    preempt_disable();
    cpu_id = smp_processor_id();
    mmc = &mm->context[cpu_id];
    cpu_mask = mm->cpu_vm_mask;
    cpu_clear(cpu_id, cpu_mask);

#iffdef DEBUG_SMP
   if (!mm)
       BUG();
#endif
--

  mm might be NULL, but this would only be detected after it
 has been dereferenced, and only then if DEBUG_SMP is defined.

  I'd suggest changing to read something like this:

--
    if ( !mm )
        BUG();

    preempt_disable();
--

Steve
--
http://www.steve.org.uk/
