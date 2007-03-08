Return-Path: <linux-kernel-owner+w=401wt.eu-S933374AbXCHVgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374AbXCHVgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:36:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933369AbXCHVgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:36:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39058 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933364AbXCHVgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:36:00 -0500
Date: Thu, 8 Mar 2007 22:34:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Zachary Amsden <zach@vmware.com>, tglx@linutronix.de,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pratap Subrahmanyam <pratap@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Daniel Hecht <dhecht@vmware.com>, Daniel Arai <arai@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: hardwired VMI crap
Message-ID: <20070308213458.GA24634@elte.hu>
References: <45EF175D.6030609@vmware.com> <1173302503.24738.795.camel@localhost.localdomain> <45EF372E.7030600@goop.org> <1173308717.24738.898.camel@localhost.localdomain> <45EF49E9.7040509@vmware.com> <20070308091019.GA19460@elte.hu> <45EFE010.7080108@vmware.com> <1173352154.24738.1023.camel@localhost.localdomain> <45F0761C.6060107@vmware.com> <45F07D07.5090003@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F07D07.5090003@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Zachary Amsden wrote:
> > We faithfully emulate lapic, io_apic, the pit, pic, and a normal
> > interrupt subsystem.
> 
> Can you not just use the apic clock driver directly then?  Do you need 
> to do anything special?

exactly. There are only two variants Linux wants to care about:

 - native hardware ABIs. If a hypervisor (like KVM) happens to do its
   stuff based on those, more power to them - we dont (and cannot) care.

 - /One/ _intelligent_ higher-level virtualization API/ABI. Xen's API is 
   quite advanced on this front. This would be shared by /all/ 
   hypervisors and could occasionally be reused by other hardware 
   platforms as well. It can be morphed via small wrappers into some
   'hypervisor personality' kind of hypervisor backends, but no
   fundamental transformation happens.

what we do _NOT_ want is some mixture of 'simplified' and 'hardwired' 
native hardware access mixed with hypercalls that somehow ends up 
creating a Frankenstein mixture of 'virtual silicon', which is specified 
nowhere else but in VMWare's proprietary hypervisor source code that we 
have no way to fix and no way to even see!

it's hard enough to get native silicon support right.

	Ingo
