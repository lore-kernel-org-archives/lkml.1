Return-Path: <linux-kernel-owner+w=401wt.eu-S1758469AbYF0Sqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469AbYF0Sqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbYF0Sqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:46:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753143AbYF0Sq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:46:29 -0400
Date: Fri, 27 Jun 2008 11:45:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: hannes@saeurebad.de, tzanussi@gmail.com, penberg@cs.helsinki.fi,
       torvalds@linux-foundation.org, compudj@krystal.dyndns.org,
       vegard.nossum@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Full conversion to early_initcall() interface,
 remove old interface.
Message-Id: <20080627114515.65b00a9e.akpm@linux-foundation.org>
In-Reply-To: <20080627142800.2c0b5cf1@linux360.ro>
References: <20080623153056.1862c14e@linux360.ro>
	<20080623172742.be332a53.akpm@linux-foundation.org>
	<20080625120151.56180b47@linux360.ro>
	<87d4m3ywpu.fsf@skyscraper.fehenstaub.lan>
	<20080627142800.2c0b5cf1@linux360.ro>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 14:28:00 +0300
Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:

> On Fri, 27 Jun 2008 12:54:21 +0200
> Johannes Weiner <hannes@saeurebad.de> wrote:
> 
> > Hi Eduard,
> 
> Hi.
>  
> > You forgot to remove the declaration from linux/interrupt.h.
> 
> The last patch was made against linux-next, as Andrew Morton
> suggested, where spawn_ksoftirqd() was declared in the scope of
> __do_pre_smp_initcall():
> @@ -793,17 +784,6 @@ static void __init __do_pre_smp_initcalls(void)
>  		do_one_initcall(*call);
>  }
>  
> -static void __init do_pre_smp_initcalls(void)
> -{
> -	extern int spawn_ksoftirqd(void);
> -
> -	init_call_single_data();
> -	migration_init();
> -	spawn_ksoftirqd();
> -	if (!nosoftlockup)
> -		spawn_softlockup_task();
> -}
> -
> 
> It may be that some other patch in -mmotm moves that into
> include/linux/interrupt.h. In linux-next with my patch, running
> $ find . -name \*.h | xargs grep "spawn_ksoftirqd"
> shows nothing.

Yes, I dropped that patch as it's no longer relevant.

> Thanks for spotting this difference.
> 
> (Using -mmotm + quilt myself is an additional headache, since git
> already does what I want in terms of patch (read commits) management;
> that's why I prefered linux-next.)

It is a bit of a pain.  I avoid asking people to raise patches against
-mm unless it's really necessary.
