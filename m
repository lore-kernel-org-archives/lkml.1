Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbXJCQh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbXJCQh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 12:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbXJCQhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 12:37:19 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50807 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbXJCQhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 12:37:17 -0400
Subject: Re: [Question] How to represent SYSTEM_RAM in kerenel/resouce.c
From: Dave Hansen <haveblue@us.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, andi@firstfloor.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, pbadari@us.ibm.com,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
In-Reply-To: <20071003103136.addbe839.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071003103136.addbe839.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 09:37:13 -0700
Message-Id: <1191429433.4939.49.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-03 at 10:31 +0900, KAMEZAWA Hiroyuki wrote:
> 
> i386 and x86_64 registers System RAM as IORESOUCE_MEM |
> IORESOUCE_BUSY.
> ia64 registers System RAM as IORESOURCE_MEM.
> 
> Which is better ?

I think we should take system ram out of the iomem file, at least.

'struct resource' is a good, cross-platform structure to use for keeping
track of which memory we have where.  So, we can share that structure to
keep track of iomem, or memory hotplug state.  But, I'm not sure we
should be intermingling system RAM and iomem like we are now in the same
instance of the structure.

-- Dave

