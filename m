Return-Path: <linux-kernel-owner+w=401wt.eu-S1765377AbXHQVTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765377AbXHQVTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbXHQVTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:19:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54668 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762570AbXHQVTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:19:33 -0400
Date: Sat, 18 Aug 2007 03:02:14 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
In-Reply-To: <alpine.LFD.0.999.0708180243380.3666@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0708180300490.3666@enigma.security.iitk.ac.in>
References: <46C233CB.9000602@am.sony.com> <1187132149.2618.2.camel@laptopd505.fenrus.org>
 <alpine.LFD.0.999.0708150454480.6482@enigma.security.iitk.ac.in>
 <20070817112253.e6a7cb33.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0708171342190.9404@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0708180243380.3666@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Aug 2007, Satyam Sharma wrote:

> On Fri, 17 Aug 2007, Christoph Lameter wrote:
> 
> > On Fri, 17 Aug 2007, Andrew Morton wrote:
> > 
> > > are we seeing a pattern here?  We could stick the unlikely inside
> > > ZERO_OR_NULL_PTR() itself.  That's a little bit sleazy though - there might
> > > be future callsites at which it is likely, who knows?
> > 
> > Thought about that myself but then there would be a weird side effect to 
> > ZERO_OR_NULL_PTR().
> 
> True, but I suspect such a side-effect to actually matter only for the
> BUG_ON case, where introducing the unlikely() would mean the output from
> the show_registers() dump during the BUG() would show a not-useful-at-all
> %%eax == 0x0000001 value, but only if CONFIG_PROFILE_LIKELY=y, admittedly.

Hang on, BUG_ON() already uses unlikely anyway. And I've just verified
from a testcase that gcc doesn't get confused by unlikely(unlikely(...))
kind of code, so we're in the clear, I think.
