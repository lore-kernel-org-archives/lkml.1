Return-Path: <linux-kernel-owner+w=401wt.eu-S937772AbZDJRio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937772AbZDJRio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760130AbZDJRid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:38:33 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:13812 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758010AbZDJRic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:38:32 -0400
Date: Fri, 10 Apr 2009 19:40:34 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrea Righi <righi.andrea@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [REGRESSION] commit 66c1ca0: {fbmem: fix fb_info->lock and 
 mm->mmap_sem ...} causes Xfbdev not working
Message-Id: <20090410194034.d13c589a.krzysztof.h1@poczta.fm>
In-Reply-To: <f17812d70904090436kd03744brca4a4bc4b85bba8@mail.gmail.com>
References: <f17812d70904090436kd03744brca4a4bc4b85bba8@mail.gmail.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 82e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Apr 2009 19:36:24 +0800
Eric Miao <eric.y.miao@gmail.com> wrote:

> This happens on my Marvell PXA310-based Littleton platform with
> Angstrom Distribution. The offending paths are many:
> 
> FBIOPUT_VSCREENINFO:
>   lock_fb_info()
>   --> fb_set_var()
>     --> fb_notifier_call_chain() [FBINFO_MISC_USEREVENT]
>       --> fbcon_event_notifier() [FB_EVENT_MODE_CHANGE]
>         --> lock_fb_info()
> 
> OK, now hang. I'd suggest a clean fix to the original assumption of
> circular locking
> issue and revert this commit first.
> 

Who should I ask to revert this commit?

Regards,
Krzysztof

----------------------------------------------------------------------
Oblej swoich znajomych... wirtualnie! ;)
http://link.interia.pl/f2119

