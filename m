Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbZJSNzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbZJSNzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 09:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbZJSNzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 09:55:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34824 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021AbZJSNzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 09:55:13 -0400
Date: Mon, 19 Oct 2009 15:54:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Jan Beulich <JBeulich@novell.com>,
       Thomas Schlichter <thomas.schlichter@web.de>,
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
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
	available
Message-ID: <20091019135422.GA9921@elte.hu>
References: <4AD449A702000078000197EE@vpn.id2.novell.com> <200910142114.12433.thomas.schlichter@web.de> <4AD6EFD7020000780001A067@vpn.id2.novell.com> <200910172148.36267.thomas.schlichter@web.de> <4ADC4A76020000780001AA49@vpn.id2.novell.com> <1255959874.2823.46.camel@sbs-t61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255959874.2823.46.camel@sbs-t61>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Mon, 2009-10-19 at 02:16 -0700, Jan Beulich wrote:
> > Functionality-wise this looks fine to me
> 
> If we are going to make ioremap() and set_memory_wc() add mtrr's in 
> non-pat case, then we need to delete the added mtrr(s) in the 
> corresponding iounmap() and set_memory_wb() aswell.
> 
> hmm, this is becoming too complex. The way i915 and other graphics 
> drivers are using set_memory_wc(), it is def a bad idea to start 
> adding mtrr's behind the back for non-pat case.

Touching MTRRs beyond working around basic bugs like non-cached RAM 
sounds like madness. The interactions with PAT are ... countless.

> Can't we just force PAT option always and we probably don't care about 
> ioremap_wc() on processors were PAT doesn't get enabled because of 
> known errata.

We can make PAT configurability dependent on EMBEDDED-y - mind sending a 
patch for that?

	Ingo
