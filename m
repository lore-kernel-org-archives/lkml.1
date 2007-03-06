Return-Path: <linux-kernel-owner+w=401wt.eu-S933131AbXCFJHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131AbXCFJHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933156AbXCFJHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:07:38 -0500
Received: from gw.goop.org ([64.81.55.164]:50607 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933149AbXCFJHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:07:34 -0500
Message-ID: <45ED2F53.2040101@goop.org>
Date: Tue, 06 Mar 2007 01:07:31 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
Subject: Re: Xen & VMI?
References: <20070305120631.GA14105@elte.hu> <1173101297.26165.39.camel@localhost.localdomain> <1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu>
In-Reply-To: <20070306081909.GA9331@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> btw., while we have everyone on the phone and talking ;) Technologically 
> it would save us a whole lot of trouble in Linux if 'external' 
> hypervisors could standardize around a single ABI - such as VMI. Is 
> there any deep reason why Xen couldnt use VMI to talk to Linux? I 
> suspect a range of VMI vectors could be set aside for Xen's dom0 (and 
> other) APIs that have no current VMI equivalent - if there's broad 
> agreement on the current 60+ base VMI vectors that center around basic 
> x86 CPU capabilities - which make up the largest portion of our 
> paravirtualization complexity. Pipe dream?

Well, we went around this about six months ago, and decided the best way
forward is the current paravirt_ops approach. 

The Xen and VMI interfaces are quite different, and have different
design goals.  VMI is fairly low-level, and is approximately a software
implementation of VT/SVM with a couple of extra bits, whereas the Xen
interface is intended to be higher level, with the expectation that the
guest cooperates more with its virtualization.  They have similarities
by necessity, but they have some fairly basic differences.

You could come up with some shim layer which makes the two interfaces
appear similar, and you could spell the name of that shim "VMI".  Or you
could call it "paravirt_ops", which is the name we chose.  And you could
implement the interface to that layer as a binary ABI, or you could make
it a normal source-level Linux kernel interface, which is what we chose
to do.

Either way, its still one of native hardware, VMI/ESX, Xen or something
else under the interface layer, and you need to test for each case
regardless of what the interface looks like.


    J
