Return-Path: <linux-kernel-owner+w=401wt.eu-S1756322AbZJVO1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbZJVO1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 10:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbZJVO1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 10:27:52 -0400
Received: from fmmailgate06.web.de ([217.72.192.247]:52345 "EHLO
	fmmailgate06.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129AbZJVO1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 10:27:52 -0400
Date: Thu, 22 Oct 2009 16:27:53 +0200
Message-Id: <1395924591@web.de>
MIME-Version: 1.0
From: Thomas Schlichter <thomas.schlichter@web.de>
To: "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Cc: JBeulich@novell.com, arjan@linux.intel.com,
       dri-devel@lists.sourceforge.net, hancockrwd@gmail.com, hmh@hmh.eng.br,
       jbarnes@virtuousgeek.org, jeremy.fitzhardinge@citrix.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, mingo@redhat.com,
       tglx@linutronix.de, thellstrom@vmware.com, tj@kernel.org,
       venkatesh.pallipadi@intel.com, x86@kernel.org, yinghai@kernel.org
Subject: =?iso-8859-15?Q?Re:_[RFC_Patch]_use_MTRR_for_write_combining_if_PAT_is?=
 =?iso-8859-15?Q?_not_available?=
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/79kcvNOsrOR2i7+QAAEZAWxVn+12C6vCaeSG0sOzBms66W
 dEaLzPNkpNdszgNjiF+JG6OWLcVZ1TGm938NaQ7Fh6x4PNMV+Je0TCCMFNo5
 Q==
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Thu, 2009-10-22 at 05:14 -0700, H. Peter Anvin wrote:
> > On 10/22/2009 09:08 PM, Thomas Schlichter wrote:
> > > And in that case (shared "struct file", one single release() call in the end) this
> > > implementation should be completely safe...
> > 
> > struct file is shared between forked processes.
> 
> That is correct. But I am referring to the ref-count getting incremented
> in Thomas's patch only in the pci_mmap_page_range() which will be called
> only during first mmap.
> 
> We need to keep track of the counts of later forks too.

When forked processes do mmap() PCI additional memory,
pci_mmap_page_range() will be called again and the corresponding (shared)
mtrr_usage_count wil be incremented. So we do keep track of later forks...

Yes, the MTRR reference count has nothing to do with the processes using this
memory, but if you want this, arch/x86/kernel/cpu/mtrr/if.c must be changed, too.

Regards,
  Thomas
