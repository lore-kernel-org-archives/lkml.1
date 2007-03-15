Return-Path: <linux-kernel-owner+w=401wt.eu-S964968AbXCOBO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964968AbXCOBO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 21:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964976AbXCOBO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 21:14:58 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46344 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964968AbXCOBO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 21:14:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm2 (BUG in pci_restore_state())
References: <20070307201915.4d579113.akpm@linux-foundation.org>
	<200703141457.06489.bjorn.helgaas@hp.com>
Date: Wed, 14 Mar 2007 19:14:24 -0600
In-Reply-To: <200703141457.06489.bjorn.helgaas@hp.com> (Bjorn Helgaas's
	message of "Wed, 14 Mar 2007 14:57:06 -0600")
Message-ID: <m1k5xjpatr.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas <bjorn.helgaas@hp.com> writes:

> In 2.6.21-rc3-mm2 (plus some move_freepages() bugfixes), I hit one
> of the warnings added by Eric's msi-debug-code.patch.  This is on an
> ia64 box, an HP rx2600.  Let me know if I can collect more information.

I think we are good. How pci_save_state and pci_restore_state were
implemented and how they were used were out of sync.  tg3 was one
of the drivers where pci_save_state and pci_restore_state were used
as part of the reset routine and were not used in pairs.

Which when combined with a pci-x or a pci-express capability
resulted in a memory leak, (that I was warning about).  This
has now been corrected upstream.

And the condition I was warning about non paired pci_save_state and
pci_restore_state is no longer a problem.

Eric
