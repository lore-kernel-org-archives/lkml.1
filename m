Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbXJCBwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbXJCBwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 21:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbXJCBwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 21:52:45 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:48497 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbXJCBwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 21:52:44 -0400
Date: Tue, 2 Oct 2007 19:52:42 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, andi@firstfloor.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, pbadari@us.ibm.com,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: Re: [Question] How to represent SYSTEM_RAM in kerenel/resouce.c
Message-ID: <20071003015242.GC12049@parisc-linux.org>
References: <20071003103136.addbe839.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003103136.addbe839.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 10:31:36AM +0900, KAMEZAWA Hiroyuki wrote:
> i386 and x86_64 registers System RAM as IORESOUCE_MEM | IORESOUCE_BUSY.
> ia64 registers System RAM as IORESOURCE_MEM.
> 
> Which is better ?

Should probably be BUSY.  Non-BUSY regions can have io resources
requested underneath them, but you wouldn't want a PCI device to be
assigned an address which overlaps with physical memory.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
