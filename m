Return-Path: <linux-kernel-owner+w=401wt.eu-S1752564AbYCOFYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbYCOFYB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 01:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbYCOFXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 01:23:52 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:53395 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbYCOFXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 01:23:52 -0400
Date: Sat, 15 Mar 2008 06:06:47 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/5] cleanups ntp.c (from Ingo)
In-Reply-To: <1205554210.6122.85.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0803150556090.1791@scrub.home>
References: <1205553852.6122.76.camel@localhost.localdomain> 
 <1205553938.6122.79.camel@localhost.localdomain>  <1205554018.6122.81.camel@localhost.localdomain>
 <1205554210.6122.85.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 14 Mar 2008, john stultz wrote:

> -#define MAX_TICKADJ		500		/* microsecs */
> +static const long	max_tickadj = 500;	/* (usec) */

That's a matter of taste, but MAX_TICKADJ just works as well, so why 
change it?

>  /* TIME_ERROR prevents overwriting the CMOS clock */
> -static int time_state = TIME_OK;	/* clock synchronization status	*/
> -int time_status = STA_UNSYNC;		/* clock status bits		*/
> -static long time_tai;			/* TAI offset (s)		*/
> -static s64 time_offset;			/* time adjustment (ns)		*/
> -static long time_constant = 2;		/* pll time constant		*/
> -long time_maxerror = NTP_PHASE_LIMIT;	/* maximum error (us)		*/
> -long time_esterror = NTP_PHASE_LIMIT;	/* estimated error (us)		*/
> -static s64 time_freq;			/* frequency offset (scaled ns/s)*/
> -static long time_reftime;		/* time at last adjustment (s)	*/
> -long time_adjust;
> -static long ntp_tick_adj;
> +static int	time_state = TIME_OK;		/* clock synch status	 */
> +int		time_status = STA_UNSYNC;	/* clock status bits	 */
> +static long	time_tai;			/* TAI offset (s)	 */
> +static s64	time_offset;			/* time adjustment (ns)	 */
> +static long	time_constant = 2;		/* pll time constant	 */
> +long		time_maxerror = NTP_PHASE_LIMIT;/* maximum error (us)	 */
> +long		time_esterror = NTP_PHASE_LIMIT;/* estimated error (us)	 */
> +static		s64 time_freq;		/* frequency offset (scaled ns/s)*/
> +static long	time_reftime;		/* time at last adjustment (s)	 */
> +long		time_adjust;
> +static long	ntp_tick_adj;

I must say I really hate this kind of formating, it either gets out of 
sync or requires reformatting. I would very strongly prefer not to 
introduce this sort of formatting here.

> +static inline u64 scale_tickadj(u64 adj)
> +{
> +	return ((adj * NSEC_PER_USEC) << NTP_SCALE_SHIFT) / NTP_INTERVAL_FREQ;
> +}

The function argument is actually s32 and depending on NTP_INTERVAL_FREQ 
it might produce a link error on 32bit archs.

bye, Roman
