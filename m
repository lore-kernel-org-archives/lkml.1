Return-Path: <linux-kernel-owner+w=401wt.eu-S1763145AbZC0BYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763145AbZC0BYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 21:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZC0BYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 21:24:33 -0400
Received: from ozlabs.org ([203.10.76.45]:59100 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817AbZC0BYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 21:24:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 3/5] lguest: avoid accidental recycling of pgdir pages
Date: Fri, 27 Mar 2009 11:54:20 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: lguest@ozlabs.org, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <200903271022.28863.rusty@rustcorp.com.au> <49CC1B1C.3080102@goop.org>
In-Reply-To: <49CC1B1C.3080102@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903271154.22450.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 March 2009 10:47:32 Jeremy Fitzhardinge wrote:
> Rusty Russell wrote:
> > Impact: potential bugfix
> >
> > In theory, the kernel could reuse the same page as pgdir for a new process
> > while the hypervisor keeps it cached.  This would have undesirable results.
> >   
> 
> You can't just do this in tlb flush?

I don't think so.  The problem is that lguest tracks 4 toplevels, using random
replacement.  This cache is indexed by cr3 value.

Lguest assumes it's told about all pte removals or changes, but simple
additions get faulted in.  If a pgdir page gets reused we'll potentially have
stale values from its previous life as a pgdir, no?

Now, I haven't *seen* this happen...
Rusty.
