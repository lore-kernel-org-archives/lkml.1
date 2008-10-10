Return-Path: <linux-kernel-owner+w=401wt.eu-S1761413AbYJJWQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761413AbYJJWQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 18:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbYJJWP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 18:15:59 -0400
Received: from tundra.namei.org ([65.99.196.166]:50505 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbYJJWP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 18:15:58 -0400
Date: Sat, 11 Oct 2008 09:15:08 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, srajiv@linux.vnet.ibm.com
Subject: Re: [PATCH 0/4] integrity
In-Reply-To: <1223648163.3596.6.camel@localhost.localdomain>
Message-ID: <alpine.LRH.1.10.0810110910070.3055@tundra.namei.org>
References: <cover.1223401603.git.zohar@linux.vnet.ibm.com>  <alpine.LRH.1.10.0810081553090.13169@tundra.namei.org>  <1223475584.3103.8.camel@localhost.localdomain>  <alpine.LRH.1.10.0810090905570.18606@tundra.namei.org>
 <1223648163.3596.6.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008, Mimi Zohar wrote:

> > > These TPM patches are base TPM changes, not really related to the
> > > integrity patches and certainly not dependent them.  However the reverse
> > > is not true.  The integrity-tpm-internal-kernel-interface patch is
> > > dependent on, at least, the TPM-rcu-locking patch.
> > 
> > Please repost the TPM patches, then.
> 
> The TPM patches were just added to the -mm tree (10/8 18:45 EDT),
> available from http://userweb.kernel.org/~akpm/mmotm/.

I've added the prereq patches to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

Please test it, and base your next version of the integrity patches on 
that branch.  Generally, if your patches depend on some other patches, you 
need to coordinate to ensure the prerequisite patches are either in the 
tree you're aiming for, or post them as part of the patchset.

Note that there are some interesting sparse warnings for the TPM code 
(not arising from the above):

drivers/char/tpm/tpm.c:493:10: error: bad constant expression
drivers/char/tpm/tpm.c:500:32: error: cannot size expression
drivers/char/tpm/tpm.c:507:10: error: bad constant expression
drivers/char/tpm/tpm.c:515:32: error: cannot size expression
drivers/char/tpm/tpm.c:547:32: error: cannot size expression
  CHECK   drivers/char/tpm/tpm_atmel.c
  CHECK   drivers/char/tpm/tpm_infineon.c
drivers/char/tpm/tpm_bios.c:412:7: warning: incorrect type in assignment (different address spaces)
drivers/char/tpm/tpm_bios.c:412:7:    expected struct acpi_table_header *virt
drivers/char/tpm/tpm_bios.c:412:7:    got void [noderef] <asn:2>*
drivers/char/tpm/tpm_bios.c:416:23: warning: incorrect type in argument 1 (different address spaces)
drivers/char/tpm/tpm_bios.c:416:23:    expected void [noderef] <asn:2>*logical_address
drivers/char/tpm/tpm_bios.c:416:23:    got struct acpi_table_header *virt


-- 
James Morris
<jmorris@namei.org>
