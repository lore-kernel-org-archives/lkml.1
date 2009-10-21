Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbZJUL6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbZJUL6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 07:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbZJUL6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 07:58:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39413 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbZJUL6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 07:58:24 -0400
Date: Wed, 21 Oct 2009 13:57:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Schlichter <thomas.schlichter@web.de>
Cc: Jan Beulich <JBeulich@novell.com>,
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
Message-ID: <20091021115734.GG16586@elte.hu>
References: <1392884759@web.de> <200910202154.20195.thomas.schlichter@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910202154.20195.thomas.schlichter@web.de>
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

> Jan Beulich wrote:
>
> > Functionality-wise this looks fine to me; whether the core sysfs 
> > changes are acceptable I can't judge, though.
> 
> OK, I think I should have addressed your comments. Unfortunately I had 
> to use a little "hack" to make pci_mmap_page_range() work for sysfs 
> and proc. I placed a "private" pointer in the beginning of both 
> per-file private structures. So this pointer can be accessed 
> independent from the caller. I hope this is acceptable.
> 
> I dropped the ioremap() and set_memory_wc() patches, I could not 
> implement reference counting for them and it may interact too much 
> with existing GPU drivers.
> 
> Again, this series should not change the current behavior if either 
> MTRR is disabled or PAT is enabled. But it helps in the case that MTRR 
> is enabled and PAT is not available.
> 
> What should be done now to get this series on the right "track"?

Can we eliminate mtrr_add_unaligned() as Suresh suggested, and still 
make it work on your testbox?

Once that's done i'll look at putting it into the x86 tree for testing. 
The acks of Suresh/Venki/Jan would be nice to have.

	Ingo
