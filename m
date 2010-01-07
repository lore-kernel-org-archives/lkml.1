Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725Ab0AGOWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab0AGOWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 09:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266Ab0AGOWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 09:22:41 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55068 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab0AGOWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 09:22:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [RFC local_t removal V1 1/4] Add add_local() and add_local_return()
Date: Thu, 7 Jan 2010 15:22:30 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
References: <20100105220417.400092933@quilx.com> <201001071445.50416.arnd@arndb.de> <20100107135757.GA6011@Krystal>
In-Reply-To: <20100107135757.GA6011@Krystal>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001071522.30632.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+4f53SQ2iFpsF0vHQsYTIowgx4bFBvpWlVcIQ
 U1kCd8ZE7higeo90MT+2xQkSEWB0nb+lspvcLArg+6Quc6ep87
 8dR3kZUo0hhcs4x/dJ9rw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 January 2010, Mathieu Desnoyers wrote:
> * Arnd Bergmann (arnd@arndb.de) wrote:
> > > > + local_irq_save(flags);
> > > > + switch (size) {
> > > > + case 1: r = (*((u8 *)ptr) += value);
> > > > +         break;
> > > > + case 2: r = (*((u16 *)ptr) += value);
> > > > +         break;
> > > > + case 4: r = (*((u32 *)ptr) += value);
> > > > +         break;
> > > > + case 8: r = (*((u64 *)ptr) += value);
> > > > +         break;
> > 
> > But I think here you actually need to add the volatile in order
> > to make these atomic assignments.
> 
> Yes, you are right. If we ever try to access these variables from a
> remote CPU with a load (but not with any concurrent store operation, as
> this would be semantically invalid), then the volatile is important.

Just to make sure everyone has the same understanding: We need the volatile
in the cast in these lines, not the one in the function prototype which
only serves to avoid warnings but has no impact on the object code when
we cast the pointer to a non-volatile type for the assignment.

	Arnd
