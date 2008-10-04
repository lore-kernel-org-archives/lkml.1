Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbYJDMKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbYJDMKb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 08:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYJDMKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 08:10:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45336 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbYJDMKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 08:10:22 -0400
Date: Sat, 4 Oct 2008 14:10:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [mmotm 02/Oct] fix buid error of autodetect_raid()
Message-ID: <20081004121012.GA582@elte.hu>
References: <20081004190725.CE3E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081004190725.CE3E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Patch against: mmotm 02 Oct
> Applied after: git-fastboot.patch
> 
> 
> fix following build error
> 
> >  CC      init/do_mounts_md.o
> >init/do_mounts_md.c: In function 'autodetect_raid':
> >init/do_mounts_md.c:278: error: implicit declaration of function 'msleep'
> >make[1]: *** [init/do_mounts_md.o] Error 1
> >make: *** [init] Error 2
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Arjan van de Ven <arjan@linux.intel.com>
> CC: Ingo Molnar <mingo@elte.hu>
> ---
>  init/do_mounts_md.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: b/init/do_mounts_md.c
> ===================================================================
> --- a/init/do_mounts_md.c
> +++ b/init/do_mounts_md.c
> @@ -1,5 +1,6 @@
>  
>  #include <linux/raid/md.h>
> +#include <linux/delay.h>

hm, linux/raid/md.h already has:

  #include <linux/delay.h>

what config triggers this build failure, and does your version of 
include/linux/raid/md.h have a linux/delay.h #include?

	Ingo
