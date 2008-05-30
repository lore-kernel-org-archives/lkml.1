Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbYE3Piy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbYE3Piy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 11:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYE3Pir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 11:38:47 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:28142 "EHLO
	outbound2-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752465AbYE3Piq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 11:38:46 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0K1OU3D-03-QP8-01
Date: Fri, 30 May 2008 09:39:19 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Wim Van Sebroeck <wim@iguana.be>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Samuel Tardieu <sam@rfc1149.net>,
       Mike Frysinger <vapier.adi@gmail.com>, Mingarelli@infomag.iguana.be,
       Thomas <Thomas.Mingarelli@hp.com>, Chen Gong <g.chen@freescale.com>,
       Gabriel C <nix.or.die@googlemail.com>
Subject: Re: drivers/watchdog/geodewdt.c: build fix
Message-ID: <20080530153919.GC12123@cosmic.amd.com>
References: <20080525100944.GA4084@infomag.infomag.iguana.be> <20080530150250.GA21945@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080530150250.GA21945@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 30 May 2008 15:37:31.0658 (UTC) FILETIME=[130716A0:01C8C26B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/05/08 17:02 +0200, Ingo Molnar wrote:
> 
> * Wim Van Sebroeck <wim@iguana.be> wrote:
> 
> > Author: Jordan Crouse <jordan.crouse@amd.com>
> > Date:   Mon Jan 21 10:07:00 2008 -0700
> > 
> >     [WATCHDOG] Add a watchdog driver based on the CS5535/CS5536 MFGPT timers
> 
> -tip testing found the following build failure on latest -git:
> 
>   drivers/watchdog/geodewdt.c: In function 'geodewdt_probe':
>   drivers/watchdog/geodewdt.c:225: error: too many arguments to function 'geode_mfgpt_alloc_timer'
>   make[1]: *** [drivers/watchdog/geodewdt.o] Error 1
>   make: *** [drivers/watchdog/geodewdt.o] Error 2
> 
> with this config:
> 
>   http://redhat.com/~mingo/misc/config-Fri_May_30_15_19_52_CEST_2008.bad
> 
> find the fix below.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Jordan Crouse <jordan.crouse@amd.com>

> ---
>  drivers/watchdog/geodewdt.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: tip/drivers/watchdog/geodewdt.c
> ===================================================================
> --- tip.orig/drivers/watchdog/geodewdt.c
> +++ tip/drivers/watchdog/geodewdt.c
> @@ -221,8 +221,7 @@ geodewdt_probe(struct platform_device *d
>  {
>  	int ret, timer;
>  
> -	timer = geode_mfgpt_alloc_timer(MFGPT_TIMER_ANY,
> -					MFGPT_DOMAIN_WORKING, THIS_MODULE);
> +	timer = geode_mfgpt_alloc_timer(MFGPT_TIMER_ANY, MFGPT_DOMAIN_WORKING);
>  
>  	if (timer == -1) {
>  		printk(KERN_ERR "geodewdt:  No timers were available\n");
> 

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

