Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbYAJTHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbYAJTHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYAJTHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:07:00 -0500
Received: from cantor.suse.de ([195.135.220.2]:50653 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbYAJTG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:06:59 -0500
To: venkatesh.pallipadi@intel.com
Cc: ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.co, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
From: Andi Kleen <andi@firstfloor.org>
References: <20080110184840.927409000@intel.com>
	<20080110184854.787474000@intel.com>
Date: Thu, 10 Jan 2008 20:06:53 +0100
In-Reply-To: <20080110184854.787474000@intel.com> (venkatesh pallipadi's message of "Thu\, 10 Jan 2008 10\:48\:42 -0800")
Message-ID: <p737iiho5yq.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

venkatesh.pallipadi@intel.com writes:

> x86_64: Map only usable memory in identity map. 

I don't think that is needed or makes sense for reserved/ACPI * etc. 
Only e820 holes should be truly unmapped because only those should
contain mmio.

> All reserved memory maps to a
> zero page. 

Why zero page?  Why not unmap.

Anyways you could make that a zillion times more simple by just rounding
the e820 areas to 2MB -- for the holes only that should be ok I think; 
i would expect them to be near always already suitably aligned.

In short this can be all done much simpler.

-Andi
