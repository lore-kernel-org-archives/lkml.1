Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbYAJTNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbYAJTNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbYAJTNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:13:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:52122 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbYAJTNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:13:09 -0500
To: venkatesh.pallipadi@intel.com
Cc: ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.co, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 07/11] PAT x86: pat-conflict resolution using linear list
From: Andi Kleen <andi@firstfloor.org>
References: <20080110184840.927409000@intel.com>
	<20080110184855.906407000@intel.com>
Date: Thu, 10 Jan 2008 20:13:08 +0100
In-Reply-To: <20080110184855.906407000@intel.com> (venkatesh pallipadi's message of "Thu\, 10 Jan 2008 10\:48\:47 -0800")
Message-ID: <p73r6gpmr3v.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

venkatesh.pallipadi@intel.com writes:
>  
>  	/* Reset the direct mapping. Can block */
> -	if (p->flags >> 20)
> -		ioremap_change_attr(p->phys_addr, p->size, 0);
> +	if (p->flags >> 20) {
> +		free_mattr(p->phys_addr, p->phys_addr + get_vm_area_size(p),
> +		           p->flags>>20);
> +		ioremap_change_attr(p->phys_addr, get_vm_area_size(p), 0);

If you really unmap all holes and forbid (or let it just return the
__va address) ioremap on anything mapped (which is probably ok) then
you can eliminate that completely.

-Andi
