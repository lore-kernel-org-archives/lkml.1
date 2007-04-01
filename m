Return-Path: <linux-kernel-owner+w=401wt.eu-S1751548AbXDARbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbXDARbj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 13:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXDARbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 13:31:39 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:48878 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbXDARbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 13:31:39 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 1 Apr 2007 10:31:29 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [patch 13/13] signal/timer/event fds v9 - KAIO eventfd support
 example ...
In-Reply-To: <Pine.LNX.4.64.0704011020000.6730@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704011029230.26331@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.16816.1175371778.13>
 <460FCA90.4000003@argo.co.il> <Pine.LNX.4.64.0704011000470.26331@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0704011020000.6730@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007, Linus Torvalds wrote:

> On Sun, 1 Apr 2007, Davide Libenzi wrote:
> > 
> > > [also, minor nit: sys_eventfd() can legitimately return 0, but you're banning
> > > its use in aio.  userspace could easily dup() and close(), but...]
> > 
> > Noone said that binary compatibility comes free ;)
> > I'm truly open to other ways of integration, but I thought that binary 
> > compatibility is the key here.
> 
> I would suggest taking "aio_reserved3" and turning it into
> 
> 	__u32 aio_flags;
> 	__u32 aio_resfd;
> 
> if so. And then some bit in the "flags" field has to be set (say, 
> "IOCB_FLAG_RESFB") to enable this codepath, instead of expecting that 
> aio_resfd == 0 is special.
> 
> It's generally always a good thing to have a "flags" field anyway, exactly 
> because it allows for future expansion. 

Makes sense. I was actually thinking of using the higher bit to signal 
that, but a flags field makes more sense.



- Davide


