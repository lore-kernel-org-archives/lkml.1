Return-Path: <linux-kernel-owner+w=401wt.eu-S935025AbXGRBx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935025AbXGRBx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 21:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbXGRBxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 21:53:19 -0400
Received: from mailhub.hp.com ([192.151.27.10]:36035 "EHLO mailhub.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027AbXGRBxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 21:53:18 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett Packard
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/2] SELinux Netlabel updates
Date: Tue, 17 Jul 2007 21:53:03 -0400
User-Agent: KMail/1.9.7
Cc: James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org, michal.k.k.piotrowski@gmail.com
References: <Line.LNX.4.64.0707171945430.10858@d.namei> <alpine.LFD.0.999.0707171719320.27353@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707171719320.27353@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707172153.03670.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2007 8:24:55 pm Linus Torvalds wrote:
> On Tue, 17 Jul 2007, James Morris wrote:
> > These are updated Netlabel/SELinux changes from Paul, reworked so that
> > they don't break userspace.  Michal says they work for him.  Please apply
> > for 2.6.23.
>
> They don't work AT ALL for me:
>
> 	security/selinux/ss/sidtab.o: In function `netlbl_enabled':
> 	sidtab.c:(.text+0x0): multiple definition of `netlbl_enabled'
> 	security/selinux/ss/ebitmap.o:ebitmap.c:(.text+0x0): first defined here
>
> Tssk.
>
> That dummy "netlbl_enabled()" should be "static inline", methinks.
>
> Also, that <net/netlabel.h> file has two blocks after each other of
>
> 	#ifdef CONFIG_NETLABEL
> 	..
> 	#else
> 	..
> 	#endif
>
> 	#ifdef CONFIG_NETLABEL
> 	..
> 	#else
> 	..
> 	#endif
>
> which might as well be cleaned up at the same time (and might have avoided
> this bug, since then the people involved would have seen the _correct_
> example in the first version)

Oh my.  I'll fix this and get another version out to James and Michal tomorrow 
morning; I have to spend the rest of the night smacking myself in the 
forehead.

-- 
paul moore
linux security @ hp
