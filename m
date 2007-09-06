Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbXIFLjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbXIFLjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 07:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbXIFLjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 07:39:44 -0400
Received: from main.gmane.org ([80.91.229.2]:41607 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbXIFLjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 07:39:43 -0400
To: Avi Kivity <public-avi-atKUWr5tajBWk0Htik3J/w@ciao.gmane.org>
Cc: public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@ciao.gmane.org,
       public-linux-mm-Bw31MaZKKs3YtjvyW6yDsg@ciao.gmane.org,
       public-kvm-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@ciao.gmane.org,
       public-general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@ciao.gmane.org
Subject: Re: [PATCH][RFC] pte notifiers -- support for external page	tables
References: <11890207643068-git-send-email-avi@qumranet.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 06 Sep 2007 13:39:23 +0200
In-Reply-To: <11890207643068-git-send-email-avi@qumranet.com>
Message-ID: <p73myw09g5w.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
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

