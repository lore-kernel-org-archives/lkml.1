Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbXIFN3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbXIFN3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 09:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbXIFN3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 09:29:04 -0400
Received: from mx1.suse.de ([195.135.220.2]:54844 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbXIFN3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 09:29:03 -0400
To: Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH][RFC] pte notifiers -- support for external page	tables
References: <11890207643068-git-send-email-avi@qumranet.com>
From: Andi Kleen <andi@firstfloor.org>
In-Reply-To: <11890207643068-git-send-email-avi@qumranet.com>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
Date: 06 Sep 2007 15:28:58 +0200
Message-ID: <p73k5r3apnp.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi-atKUWr5tajBWk0Htik3J/w@public.gmane.org> writes:
> 
> pte notifiers are different from paravirt_ops: they extend the normal
> page tables rather than replace them; and they provide high-level information
> such as the vma and the virtual address for the driver to use.

Sounds like a locking horror to me.  To do anything with page tables
you need locks. Both for the kernel page tables and for your new tables.

What happens when people add all
things of complicated operations in these notifiers? That will likely
happen and then everytime you change something in VM code they 
will break. This has the potential to increase the cost of maintaining
VM code considerably, which would be a bad thing.

This is quite different from paravirt ops because low level pvops
can typically run lockless by just doing some kind of hypercall directly.
But that won't work for maintaining your custom page tables.

-Andi
