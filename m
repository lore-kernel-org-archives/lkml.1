Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbXCLHXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbXCLHXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 03:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933535AbXCLHXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 03:23:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:60344 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932857AbXCLHXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 03:23:06 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18ZOe1o4u4ZdXqxVAIgUtk0Po8QxedSFksShWjEaL
	L7+jy1piZjORu/
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070311121038.GA9146@elte.hu>
References: <200703111457.17624.kernel@kolivas.org>
	 <1173613149.6927.29.camel@Homer.simpson.net>
	 <20070311121038.GA9146@elte.hu>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 08:22:54 +0100
Message-Id: <1173684174.6659.13.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-11 at 13:10 +0100, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > > Full patch for 2.6.21-rc3-mm2: 
> > > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2-rsdl-0.29.patch
> > 
> > I'm seeing a cpu distribution problem running this on my P4 box.
> 
> > With 2.6.21-rc3, X/Gforce maintain their ~50% cpu (remain smooth), and 
> > the encoders (100%cpu bound) get whats left when Amarok isn't eating 
> > it.
> > 
> > I plunked the above patch into plain 2.6.21-rc3 and retested to 
> > eliminate other mm tree differences, and it's repeatable.  The nice 5 
> > cpu hogs always receive considerably more that the nice 0 sleepers.
> 
> hm. Do you get the same same problem on UP too? (i.e. lets eliminate any 
> SMP/HT artifacts)

Behavior is slightly different with a UP kernel.  Neither encoder
receives more cpu than X, but they each still receive more than gforce.
The distribution of X/Gforce vs lame/lame averages per eyeball to
roughly ~50:50.

I noticed Con posted an accounting fix, and applied it.  No change.

	-Mike

