Return-Path: <linux-kernel-owner+w=401wt.eu-S935405AbYEBWCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935405AbYEBWCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759386AbYEBWCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:02:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33086
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758825AbYEBWCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:02:44 -0400
Date: Fri, 02 May 2008 15:02:43 -0700 (PDT)
Message-Id: <20080502.150243.146424084.davem@davemloft.net>
To: jeremy@goop.org
Cc: suresh.b.siddha@intel.com, torvalds@linux-foundation.org,
       venkatesh.pallipadi@intel.com, trini@kernel.crashing.org,
       akpm@linux-foundation.org, bunk@kernel.org, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: huge gcc 4.1.{0,1} __weak problem
From: David Miller <davem@davemloft.net>
In-Reply-To: <481B8376.4050206@goop.org>
References: <alpine.LFD.1.10.0805011729540.5994@woody.linux-foundation.org>
	<20080502003947.GB28173@linux-os.sc.intel.com>
	<481B8376.4050206@goop.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Fri, 02 May 2008 14:11:18 -0700

> Suresh Siddha wrote:
> > On Thu, May 01, 2008 at 05:34:34PM -0700, Linus Torvalds wrote:
> >   
> >> Is it always about inlining? If so, can't we add a __noinline__ to the 
> >> declaration of __weak?
> >>     
> >
> > We tried that and it was still getting inlined.
> 
> That's a pity.  I've worked around this bug with noinline before.

It's "constness", as Jakub mentioned, not inlineability, that triggers
this bug.

That's why his workaround of using an empty asm("") to the function is
an effective workaround, because the compiler can no longer internally
decide that the function is "const".
