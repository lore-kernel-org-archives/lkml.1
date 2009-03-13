Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbZCMR4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbZCMR4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757933AbZCMR4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:56:11 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:56655 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757548AbZCMR4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:56:10 -0400
Subject: VMI broken on tip/master...
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       the arch/x86 maintainers <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 13 Mar 2009 10:56:08 -0700
Message-Id: <1236966968.14680.15.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter, 

I was seeing a early fault when running tip/master with VMI enabled on
VMware platform. 
This early fault was in the vmi_patch code where we are applying
paravirt_alternatives. After some trials i noticed that this is
reproducible only with CONFIG_TRACING. With that disabled my VM boots
again. 

I started a git bisect after that, and git pointed to this as the bad
commit

commit 6cc3c6e12bb039047974ad2e7e2d46d15a1b762f
    trace_clock: fix preemption bug

I then reverted that commit from tip/master and the system did boot. 
But I fail to understand how this simple patch would be causing things
to fail in VMI. Any ideas ?

Thanks,
Alok

