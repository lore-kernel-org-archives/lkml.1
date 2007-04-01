Return-Path: <linux-kernel-owner+w=401wt.eu-S933669AbXDARHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669AbXDARHS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 13:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933666AbXDARHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 13:07:18 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:48853 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933660AbXDARHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 13:07:17 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 1 Apr 2007 10:07:15 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Avi Kivity <avi@argo.co.il>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [patch 13/13] signal/timer/event fds v9 - KAIO eventfd support
 example ...
In-Reply-To: <460FCA90.4000003@argo.co.il>
Message-ID: <Pine.LNX.4.64.0704011000470.26331@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.16816.1175371778.13>
 <460FCA90.4000003@argo.co.il>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007, Avi Kivity wrote:

> What is the motivation for adding aio_resfd to an individual iocb instead of
> the entire io context?  It seems redundant, as you can already create multiple
> io contexts to wait on.

To add it to the context, you need to either change the context create API 
(I think no-go here), or add a new syscall just to handle that.
Doing it in the iocb gives finer grained setup, but can be more work for 
the user that wants to use it for all the iocbs.


> [also, minor nit: sys_eventfd() can legitimately return 0, but you're banning
> its use in aio.  userspace could easily dup() and close(), but...]

Noone said that binary compatibility comes free ;)
I'm truly open to other ways of integration, but I thought that binary 
compatibility is the key here.



- Davide


