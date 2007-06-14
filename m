Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbXFNSdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbXFNSdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 14:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbXFNSdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 14:33:10 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:12167 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751063AbXFNSdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 14:33:08 -0400
Subject: RE: [patch 0/3] no MAX_ARG_PAGES -v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ollie Wild <aaw@google.com>, linux-kernel@vger.kernel.org,
       parisc-linux@lists.parisc-linux.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>
In-Reply-To: <617E1C2C70743745A92448908E030B2A01AF8CE6@scsmsx411.amr.corp.intel.com>
References: <617E1C2C70743745A92448908E030B2A01AF8CE6@scsmsx411.amr.corp.intel.com>
Content-Type: text/plain
Date: Thu, 14 Jun 2007 20:32:43 +0200
Message-Id: <1181845964.5806.2.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-14 at 11:22 -0700, Luck, Tony wrote:
> > > Interesting.  If you're exceeding your stack ulimit, you should be
> > > seeing either an "argument list too long" message or getting a
> > > SIGSEGV.  Have you tried bypassing wc and piping the output straight
> > > to a file?
> >
> > I think it sends SIGKILL on failure paths.
> 
> Setting stack limit to unlimited I managed to exec with 10MB, and
> "wc" produced the correct output when it (finally) ran, so no
> odd limits being hit in there.

Ah, good :-)

> Ah ... running the 34*100K case direct from my shell prompt, I
> do see a "Killed" that must get lost when I run this in the
> shell script loop.

Yes, so it seems we just trip the stack limit after we cross the point
of no return.

I started looking into growing the stack beforehand and perhaps
shrinking the stack after we're done. That would get most if not all
these failures before the point of no return.

