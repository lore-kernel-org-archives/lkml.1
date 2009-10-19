Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbZJSPcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbZJSPcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756643AbZJSPcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:32:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49217 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551AbZJSPco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:32:44 -0400
Date: Mon, 19 Oct 2009 17:31:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Schlichter <thomas.schlichter@web.de>
Cc: Jan Beulich <JBeulich@novell.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, arjan@linux.intel.com,
       dri-devel@lists.sourceforge.net, hancockrwd@gmail.com, hmh@hmh.eng.br,
       hpa@zytor.com, jbarnes@virtuousgeek.org, jeremy.fitzhardinge@citrix.com,
       linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
       thellstrom@vmware.com, tj@kernel.org, venkatesh.pallipadi@intel.com,
       x86@kernel.org, yinghai@kernel.org
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
	available
Message-ID: <20091019153134.GA18198@elte.hu>
References: <1392906098@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392906098@web.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Schlichter <thomas.schlichter@web.de> wrote:

> I don't think this is a good idea, Robert Hancock wrote there may be 
> millions of such Laptops (Core Solo/Duo erratum AE7, Pentium M erratum 
> Y31) :
>
>   http://marc.info/?l=linux-kernel&m=125537136105246&w=2
> 
> > or Perhaps just try to add mtrr only for the pci mmap case like the 
> > 4th patch in this series..
> 
> I'd prefer this! ;-)

Hm, we could perhaps do that - but i think we should only do that on 
systems that have PAT disabled.

Which brings up the question of how to properly QA such a narrow segment 
of the market. Maybe disabling CONFIG_X86_PAT should enable that logic 
too.

	Ingo
