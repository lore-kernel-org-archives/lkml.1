Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbZJURgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbZJURgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 13:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbZJURgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 13:36:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36203 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024AbZJURgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 13:36:16 -0400
Date: Wed, 21 Oct 2009 19:35:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: Thomas Schlichter <thomas.schlichter@web.de>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Robert Hancock <hancockrwd@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Tejun Heo <tj@kernel.org>, x86@kernel.org,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       dri-devel@lists.sourceforge.net, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       Thomas Hellstrom <thellstrom@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
	available
Message-ID: <20091021173514.GA32227@elte.hu>
References: <1394846127@web.de> <4ADF32A0020000780001B20A@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADF32A0020000780001B20A@vpn.id2.novell.com>
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


* Jan Beulich <JBeulich@novell.com> wrote:

> > So if it's OK for Jan, I'll reduce the functionality again and use 
> > mtrr_add() instead. Btw. this simply means to drop 
> > mtrr_add_unaligned(), all the other parts are still required for 
> > reference counting and a proper mtrr_del() on file close.
> 
> I'm perfectly fine with just handling the aligned case, as long as the 
> code checks that the alignment constraints are met.

It could even emit a debug warning if they are not met - that way we'll 
see how important the unaligned case is.

	Ingo
