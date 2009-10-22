Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbZJVKcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbZJVKcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 06:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZJVKcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 06:32:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:20563 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbZJVKcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 06:32:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,604,1249282800"; 
   d="scan'208";a="460169356"
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
 available
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Thomas Schlichter <thomas.schlichter@web.de>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Beulich <JBeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Robert Hancock <hancockrwd@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Tejun Heo <tj@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Ingo Molnar <mingo@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <200910212201.36578.thomas.schlichter@web.de>
References: <1394846127@web.de>
	 <4ADF32A0020000780001B20A@vpn.id2.novell.com>
	 <20091021173514.GA32227@elte.hu>
	 <200910212201.36578.thomas.schlichter@web.de>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 22 Oct 2009 02:53:29 -0700
Message-Id: <1256205210.2530.28.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-21 at 13:01 -0700, Thomas Schlichter wrote:
> OK, so I think the attached patches should do it. Hopefully I have addressed 
> all your comments.

Thomas,

I have couple of issues with this patchset still. pci_mmap_page_range()
doesn't get called for each fork(). So, we won't be ref counting the
mtrr usage properly.

I need to think a bit more carefully on this. Can I get back to you
early next week on this, as I am traveling and need to think through
this?

We already keep track of some of the PAT ref counting using
track_pfn_vma_copy(). And we need to extend/use something similar here.

Even if we need to extend sysfs or pci vma ops, we need to increment and
decrement the ref count of the mtrr register that gets used. There is no
need to go through num_var_ranges etc.

thanks,
suresh

