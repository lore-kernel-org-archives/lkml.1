Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbYDITT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbYDITT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 15:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbYDITTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 15:19:51 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:53009 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbYDITTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 15:19:51 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 9 Apr 2008 12:19:50 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       zach.brown@oracle.com, jroberson@chesapeake.net
Subject: Re: [patch] eventfd/kaio integration fix
In-Reply-To: <20080409120812.cad8f173.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0804091217150.7000@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0804091138050.7000@alien.or.mcafeemobile.com>
 <20080409120812.cad8f173.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2008, Andrew Morton wrote:

> On Wed, 9 Apr 2008 11:45:47 -0700 (PDT)
> Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > Jeff Roberson discovered a race when using kaio eventfd based 
> > notifications. This patch fixes the race by moving the notification inside 
> > the spinlocked section of kaio.
> 
> Missing information.
> 
> What are the consequences of this race, when it occurs?

This was described in the original email. I posted a patch back then 
(waiting for Jeff test feedback - that never came), but then I forgot 
about it till now:

http://groups.google.com/group/linux.kernel/browse_thread/thread/e814b54c14198616



> > The operation is safe since eventfd 
> > spinlock and kaio one are unrelated.
> 
> Yes, it's safe from that perspective.
> 
> However with this patch applied, we will no longer run eventfd_signal() if
> kiocbIsCancelled(iocb).  Convincing is needed, please?

This was the intended behaviour. No event was actually *ready*, so no need 
to signal completion of an event.



- Davide


