Return-Path: <linux-kernel-owner+w=401wt.eu-S1762483AbYEPADu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762483AbYEPADu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 20:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbYEPADm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 20:03:42 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52670 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755350AbYEPADl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 20:03:41 -0400
Date: Thu, 15 May 2008 19:03:40 -0500
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>
Cc: akpm@linux-foundation.org, tglx@linutronix.de, steiner@sgi.com,
       travis@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] x86 boot: add code to add BIOS provided EFI
 memory entries to kernel
Message-Id: <20080515190340.b232ca7d.pj@sgi.com>
In-Reply-To: <20080514151558.148486.91282.sendpatchset@jackhammer.engr.sgi.com>
References: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
	<20080514151558.148486.91282.sendpatchset@jackhammer.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ying Huang, H. Peter Anvin, Andi Kleen, Ingo Molnar (and anyone else
interested):

I invite your review of these patches, especially 7, 9 and 10 of the
set of 10, that I posted yesterday.

In combination, I believe that they allow passing more than E820MAX
(128) memory map entries from EFI firmware to a booting kernel, beyond
the E820 constraints of non-EFI legacy BIOS's, without changing the
EFI interface interface.  My understanding of the EFI interface is
that it already allows for this, and that we just needed to add the
ability, as done in these patches, for the kernel to make use of this.

The separate work of Ying Huang, to leverage Andi's reserve_early()
and to revise the EFI interface, to pass multiple pages of information
from the EFI firmware to the kernel at boot is, I presume, still needed
for other extensions, such as for passing more hard disk drive entries.

But the particular extension of interest to me, passing more memory map
entries (for future x86_64 systems with more than 128 memory nodes)
can I believe be done fairly easily, with these patches, with no need
of revising the EFI interface or reserving early memory, and with code
that is compatible across both x86_32 and x86_64 arch's.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
