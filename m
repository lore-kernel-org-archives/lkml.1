Return-Path: <linux-kernel-owner+w=401wt.eu-S932336AbZJSVuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbZJSVuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 17:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932289AbZJSVui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 17:50:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:12541 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264AbZJSVui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 17:50:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,587,1249282800"; 
   d="scan'208";a="200929012"
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
	available
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Schlichter <thomas.schlichter@web.de>,
       Jan Beulich <JBeulich@novell.com>,
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
In-Reply-To: <20091019153134.GA18198@elte.hu>
References: <1392906098@web.de>  <20091019153134.GA18198@elte.hu>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 19 Oct 2009 14:49:27 -0700
Message-Id: <1255988967.2576.36.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-19 at 08:31 -0700, Ingo Molnar wrote:
> * Thomas Schlichter <thomas.schlichter@web.de> wrote:
> 
> > I don't think this is a good idea, Robert Hancock wrote there may be 
> > millions of such Laptops (Core Solo/Duo erratum AE7, Pentium M erratum 
> > Y31) :
> >
> >   http://marc.info/?l=linux-kernel&m=125537136105246&w=2
> > 
> > > or Perhaps just try to add mtrr only for the pci mmap case like the 
> > > 4th patch in this series..
> > 
> > I'd prefer this! ;-)
> 
> Hm, we could perhaps do that - but i think we should only do that on 
> systems that have PAT disabled.
> 
> Which brings up the question of how to properly QA such a narrow segment 
> of the market. Maybe disabling CONFIG_X86_PAT should enable that logic 
> too.

Also, I think we can simplify and avoid mtrr_add_unaligned() and worry
only about the pci mmap aligned cases etc. Those are the only
interesting ones.

thanks,
suresh

