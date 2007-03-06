Return-Path: <linux-kernel-owner+w=401wt.eu-S965082AbXCFQ33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965082AbXCFQ33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965280AbXCFQ32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:29:28 -0500
Received: from BACHE.ECE.CMU.EDU ([128.2.129.23]:41170 "EHLO bache.ece.cmu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965082AbXCFQ31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:29:27 -0500
X-Greylist: delayed 1736 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Mar 2007 11:29:27 EST
Message-ID: <45ED901D.50404@cmu.edu>
Date: Tue, 06 Mar 2007 11:00:29 -0500
From: "Jonathan M. McCune" <jonmccune@cmu.edu>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: INIT IPI help
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have Linux kernel 2.6.20-rc5 running on an AMD64 CPU, although I'm
running an i386 (not amd64) kernel.  I need to send an INIT
inter-processor-interrupt from the BSP to all APs (there is one AP in my
case since my system has a dual-core CPU).  After using CPU-hotplug to
disable CPU1, I am using this code to [hopefully] send an IPI:

apic_write(APIC_ICR, APIC_DEST_ALLBUT | APIC_INT_ASSERT | APIC_DM_INIT);

while(apic_read(APIC_ICR) & APIC_ICR_BUSY) {
    mdelay(1);
}

My motivation for doing this is in preparation for executing an SKINIT
instruction, which requires all APs to be in the INIT state so that a
copy of the up-to-64KB Secure Loader Block (SLB) provided as an argument
to SKINIT can be successfully transmitted to the system's TPM where it
is hashed.  No hash value is being computed, which is my problem.

Now, SKINIT is a complex instruction with multiple opportunities to
fail, and my motivation for writing this email is only to get a sense of
whether my code above is the right way to send an INIT IPI to the AP.
After executing the code above, can I be confident that the AP is in the
INIT state?

Thanks,
-Jon


