Return-Path: <linux-kernel-owner+w=401wt.eu-S1752288AbZJTWAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbZJTWAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 18:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbZJTV77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 17:59:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:8348 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbZJTV76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 17:59:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,593,1249282800"; 
   d="scan'208";a="201431576"
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
 available
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Thomas Schlichter <thomas.schlichter@web.de>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Beulich <JBeulich@novell.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       "hancockrwd@gmail.com" <hancockrwd@gmail.com>,
       "hmh@hmh.eng.br" <hmh@hmh.eng.br>, "hpa@zytor.com" <hpa@zytor.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "jeremy.fitzhardinge@citrix.com" <jeremy.fitzhardinge@citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "thellstrom@vmware.com" <thellstrom@vmware.com>,
       "tj@kernel.org" <tj@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "yinghai@kernel.org" <yinghai@kernel.org>
In-Reply-To: <200910202235.12277.thomas.schlichter@web.de>
References: <1392906098@web.de> <20091019153134.GA18198@elte.hu>
	 <200910202235.12277.thomas.schlichter@web.de>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 20 Oct 2009 14:59:23 -0700
Message-Id: <1256075963.2685.7.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-20 at 13:35 -0700, Thomas Schlichter wrote:
> What do you think about the latest version of my patch series I just sent?

I think we can simplify this  by just using mtrr_add_page() and avoid
all the complexity that comes with mtrr_add_unaligned().

pci_mmap_range() should call one mtrr_add_page() if the base and size
are nicely aligned. Almost all the cases, this is the usage sequence
here anyway.

thanks,
suresh

