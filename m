Return-Path: <linux-kernel-owner+w=401wt.eu-S1762880AbXEPTXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762880AbXEPTXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758873AbXEPTXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:23:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463AbXEPTX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:23:29 -0400
Date: Wed, 16 May 2007 15:22:48 -0400
From: Dave Jones <davej@redhat.com>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Joachim Deguara <joachim.deguara@amd.com>
Subject: Re: [BUG] (regression) AMD k6-III/450 won't boot w/2.6.22-rc1
Message-ID: <20070516192248.GA16810@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Bob Tracy <rct@gherkin.frus.com>, Chuck Ebbert <cebbert@redhat.com>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
	Joachim Deguara <joachim.deguara@amd.com>
References: <20070516163000.GE30166@redhat.com> <20070516191156.69576DBA1@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516191156.69576DBA1@gherkin.frus.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 02:11:56PM -0500, Bob Tracy wrote:

 > flags		: fpu vme de pse tsc msr mce cx8 pge mmx syscall 3dnow k6_mtrr
 > bogomips	: 902.78
 > clflush size	: 32

Ah so it really does think it has mce.
I just dug out the datasheet for the K6-3, and true enough, it did have MCE, however,
it isn't intel compatible. It has two MSRs (MCAR at 0x0, and MCTR at 0x01).
Then the punchline..

"Because the processor does not support machine check exceptions, the contents of the
MCAR and MCTR are only affected by the WRMSR instruction and by RESET being sampled
asserted (where all bits in each register are reset to 0)."

In short, it's useless.
We could clear the capability bit and pretend it isn't there, at no loss of
functionality, or we could revert back to doing model checks instead of cpuid flag checks.

	Dave

-- 
http://www.codemonkey.org.uk
