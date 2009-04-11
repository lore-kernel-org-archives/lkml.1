Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbZDKScC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbZDKScC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 14:32:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbZDKSbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 14:31:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754712AbZDKSbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 14:31:52 -0400
Date: Sat, 11 Apr 2009 11:21:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Eric Miao <eric.y.miao@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrey Borzenkov <arvidjaar@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org, Dave Jones <davej@redhat.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Pavel Roskin <proski@gnu.org>
Subject: Re: [REGRESSION] commit 66c1ca0: {fbmem: fix fb_info->lock and
 mm->mmap_sem ...} causes Xfbdev not working
Message-Id: <20090411112131.cc38dcf0.akpm@linux-foundation.org>
In-Reply-To: <20090411150359.GA8265@linux>
References: <f17812d70904090436kd03744brca4a4bc4b85bba8@mail.gmail.com>
	<20090409125850.GA2727@linux>
	<20090410222122.87be60f6.krzysztof.h1@poczta.fm>
	<20090410220521.GB21294@linux>
	<20090411080415.7fe924a2.krzysztof.h1@poczta.fm>
	<49E05C36.9040204@s5r6.in-berlin.de>
	<20090411110840.GA7108@linux>
	<20090411150359.GA8265@linux>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Apr 2009 17:04:00 +0200 Andrea Righi <righi.andrea@gmail.com> wrote:

> fbdev: fix info->lock deadlock in fbcon_event_notify()
> 
> fb_notifier_call_chain() is called with info->lock held, i.e. in
> do_fb_ioctl() => FBIOPUT_VSCREENINFO => fb_set_var() and the some
> notifier callbacks, like fbcon_event_notify(), try to re-acquire
> info->lock again.
> 
> Remove the lock/unlock_fb_info() in all the framebuffer notifier
> callbacks' and be sure to always call fb_notifier_call_chain() with
> info->lock held.

Thanks.  So do you think we should proceed with this patch instead of
reverting 66c1ca0?
