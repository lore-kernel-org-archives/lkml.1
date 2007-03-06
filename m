Return-Path: <linux-kernel-owner+w=401wt.eu-S1030326AbXCFJ1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030326AbXCFJ1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030344AbXCFJ1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:27:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44753 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030326AbXCFJ1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:27:06 -0500
Date: Tue, 6 Mar 2007 10:26:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
Subject: Re: Xen & VMI?
Message-ID: <20070306092636.GC26073@elte.hu>
References: <20070305120631.GA14105@elte.hu> <1173101297.26165.39.camel@localhost.localdomain> <1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2F53.2040101@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45ED2F53.2040101@goop.org>
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

> You could come up with some shim layer which makes the two interfaces 
> appear similar, and you could spell the name of that shim "VMI".  Or 
> you could call it "paravirt_ops", which is the name we chose.  And you 
> could implement the interface to that layer as a binary ABI, or you 
> could make it a normal source-level Linux kernel interface, which is 
> what we chose to do.

i think you are missing my point.

paravirt_ops is a Linux-internal abstraction that tries to make our life 
easier but it has no relevance whatsoever to an external hypervisor - be 
that Xen, VMWare/ESX or Windows/Longhorn.

What matters is the /ABI/ that the hypervisor uses to talk to a Linux 
guest. In the VMWare/ESX case that's VMI. In the Xen case that's the 
hypercall page call-table ABI or the legacy int $0x82 ABI.

My suggestion would be for Linux to make only a /single/ external ABI 
promise: VMI. (and we can extend it with higher-level paravirt ops, 
etc.)

paravirt_ops has ZERO relevance here... Anyone who suggests that 
paravirt_ops somehow magically hides the ABIs that are behind it (and 
its effects on Linux) is smoking something real funny ;-)

	Ingo
