Return-Path: <linux-kernel-owner+w=401wt.eu-S1762492AbZBEBuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762492AbZBEBuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:50:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbZBEBtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:49:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49526 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756777AbZBEBto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:49:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: [PATCH -mmotm] fbmem: fix fb_info->lock and mm->mmap_sem circular locking dependency
Date: Thu, 5 Feb 2009 02:49:25 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
References: <498817E2.3020008@gmail.com> <1233783983-28802-1-git-send-email-righi.andrea@gmail.com> <200902050058.31680.rjw@sisk.pl>
In-Reply-To: <200902050058.31680.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902050249.27244.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009, Rafael J. Wysocki wrote:
> On Wednesday 04 February 2009, Andrea Righi wrote:
> > Fix this circular locking dependencies in the frame buffer console
> > driver pushing down the mutex fb_info->lock.
> > 
> > Circular locking dependecies occur calling the blocking
> > fb_notifier_call_chain() with fb_info->lock held. Notifier callbacks can
> > try to acquire mm->mmap_sem, while fb_mmap() acquires the locks in the
> > reverse order mm->mmap_sem => fb_info->lock.
> 
> Does this fix a Bugzilla bug?  If so, then which one?

Never mind, found it.

Thanks,
Rafael
